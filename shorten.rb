class Shorten
  DICT_PATH = '/usr/share/dict/words'

  # Create a dict array for each letter of the alphabet
  # These are populated with DICT_PATH contents
  def initialize(dictionary=DICT_PATH)
    a_through_z = ('a'..'z').to_a
    a_through_z.each {|x| instance_variable_set(:"@dict_#{x}", [])}
    File.open(dictionary).each do |line|
      line.downcase!
      next unless line[/^[a-z]+$/]
      instance_variable_get(:"@dict_#{line[0]}").push(line.chomp)
    end
  end

  def sentence(arg="the expeditious brown omnivorous mammal leapfrogged over the lethargic canine")
    word_lookup = Proc.new {|word| Word.new(word, self).shorten }
    arg.split.map(&word_lookup).join(' ')
  end

  # Same as #sentence, except encode shortened words by marking them with a \t suffix
  def encode(arg)
    word_lookup = Proc.new do |word|
      output = ""
      output += _word = Word.new(word, self).shorten
      output += "\t" if _word.truncated?
      output
    end
    arg.split.map(&word_lookup).join(' ')
  end

  # Decode an encoded sentence, expanding words that are shortened
  def decode(arg)
    word_lookup = Proc.new {|word| Word.new(word, self).expand}
    # This is a regex so that whitespace (\t) is not ignored
    arg.split(/ /).map(&word_lookup).join(' ')
  end

  # Return an instance of Shorten::Word
  def word(arg)
    Word.new(arg, self)
  end

  class Word < String
    attr_accessor :truncated, :original
    protected :original=, :truncated=
    alias :"truncated?" :truncated

    def initialize(arg="quintessential", shorten)
      @truncated = false
      @original = arg.downcase
      # Reference to outer class Shorten
      @shorten = shorten
      super(arg)
    end

    # Take a word, and shorten it to be unambiguous if possible
    # Shortened words will store the #original, and whether they were #truncated
    def shorten
      (1..@original.length).to_a.each do |x|
        prefix = @original.slice(0, x)
        words_matching_prefix = Proc.new {|y| y[/^#{prefix}/]}
        matches = @shorten.instance_variable_get(:"@dict_#{@original[0]}").select(&words_matching_prefix)
        if matches.length <= 1
          _word = self.class.new(prefix, @shorten)
          _word.truncated = true
          _word.original = @original
          return _word
        end
      end
      _word = self.class.new(@original, @shorten)
    end

    # Given a word that was shortened and encoded, expand that word to its original value
    def expand
      return self unless @original[/\t$/]
      word_without_expansion_encoding = @original.gsub(/\t/,'')
      match = Proc.new {|word| word[/^#{word_without_expansion_encoding}/]}
      @shorten.instance_variable_get(:"@dict_#{@original[0]}").detect(&match)
    end
  end
end
