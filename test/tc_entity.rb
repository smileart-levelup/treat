module Treat
  module Tests
    class TestEntity < Test::Unit::TestCase
      def setup
        @text = Treat::Entities::Text.new
        
        @sentence = Treat::Entities::Sentence.new
        
        @noun_phrase = Treat::Entities::Phrase.new
        @noun_phrase.set :tag, 'NP'
        @verb_phrase = Treat::Entities::Phrase.new
        @verb_phrase.set :tag, 'VP'
        @adj_phrase = Treat::Entities::Phrase.new
        @adj_phrase.set :tag, 'ADJP'
        
        @det = Treat::Entities::Word.new('The')
        @det.set :cat, :determiner
        @det.set :tag, 'DT'
        @adj = Treat::Entities::Word.new('lazy')
        @adj.set :cat, :adjective
        @adj.set :tag, 'JJ'
        @noun = Treat::Entities::Word.new('fox')
        @noun.set :cat, :noun
        @noun.set :tag, 'NN'
        @aux = Treat::Entities::Word.new('is')
        @aux.set :cat, :verb
        @aux.set :tag, 'VBZ'
        @verb = Treat::Entities::Word.new('running')
        @verb.set :cat, :verb
        @verb.set :tag, 'VBG'
        @dot = Treat::Entities::Punctuation.new('.')
        
        @text << @sentence << [@noun_phrase, @verb_phrase, @dot]
        @noun_phrase << [@det, @adj_phrase, @noun]
        @adj_phrase << @adj
        @verb_phrase << [@aux, @verb]
      end

      def test_respond_to_missing
      
      end
      
      def test_registrable
        assert_equal @text.token_registry, @verb.token_registry
        assert_equal @noun, @text.token_registry[:id][@noun.id]
        assert_equal [@noun], @text.token_registry[:value][@noun.value]  
      end


      def test_delegatable_visitable
        assert_raise(Treat::Exception) do 
          @text.encoding(:nonexistent)
        end
        assert_nothing_raised do
          @text.format
        end
      end
      
      def test_type
        assert_equal :text, @text.type
      end
      
      def test_printers
        assert_nothing_raised do
          @text.to_s
          @text.to_string
          @text.short_value
          @text.inspect
        end
      end

      def test_magic_methods
        assert_equal @sentence, @text.sentence
        assert_equal [@sentence], @text.sentences
        assert_equal 1, @text.sentence_count
        
        assert_equal [@det], @text.words_with_value('The')
        assert_equal [@verb], @text.words_with_tag('VBG')
        
        assert_equal @noun, @text.noun
        assert_equal [@aux, @verb], @text.verbs
        assert_equal 6, @text.token_count
        
        @text.each_sentence do |s|
          assert_equal @sentence, s
        end
        @text.each_noun do |n|
          assert_equal @noun, n
        end
        @text.each_with_value('The') do |x|
          assert_equal @det, x
        end
        
        assert_equal @sentence, @noun.parent_sentence
      end

      def test_features
        @verb.set :test, :test
        assert_equal :test,  @verb.test
        assert_raise(Treat::Exception) { @verb.nonexistent } 
      end
      
    end
  end
end
