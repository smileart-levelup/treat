module Treat
  module Resources
    # Dictionnary of ISO-639-1, ISO-639-2 language codes,
    # as well as their full text description in both
    # English and French.
    module Languages
      ISO639_1 = 1
      ISO639_2 = 2
      # Describe a language code (ISO-639-1 or ISO-639-2)
      # or its full text description in full French or English.
      def self.describe(lang, desc_lang = :en)
        raise "Must provide a non-nil language identifier to describe." if lang.nil?
        lang = find(lang).to_s
        if [:en, :eng, :english, :anglais].include?(desc_lang)
          l = @@english_full.key(lang)
        elsif [:fr, :fra, :french, :french].include?(desc_lang)
          l = @@french_full.key(lang)
        else
          raise Treat::Exception,
          "Unknown language to describe: #{desc_lang}."
        end
        not_found(lang) if l.nil?
        l.intern
      end
      # Raise an error message when a language code
      # or description is not found and suggest 
      # possible misspellings.
      def self.not_found(lang)
        msg = "Language '#{lang}' does not exist."
        all = @@iso639_2.keys + @@iso639_1.keys +
              @@english_full.keys + @@french_full.keys
        msg += did_you_mean?(all, lang)
        raise Treat::Exception, msg
      end
      # Find a language by ISO-639-1 or ISO-639-2 code
      # or full name (in English or French) and return
      # the ISO-639-1 or ISO-639-2 language code as a 
      # lowercase identifier.
      def self.find(lang, rc = ISO639_2)
        raise "Must provide a non-nil language identifier to describe." if lang.nil?
        get_languages
        lang = lang.to_s.downcase
        if @@iso639_1.has_key?(lang)
          return :"#{lang}" if rc == ISO639_1
          return :"#{@@iso639_1[lang]}" if rc == ISO639_2
        elsif @@iso639_2.has_key?(lang)
          return :"#{lang}" if rc == ISO639_2
          return :"#{@@iso639_2[lang]}" if rc == ISO639_1
        elsif @@english_full.has_key?(lang)
          return :"#{@@english_full[lang]}" if rc == ISO639_2
          return :"#{@@iso639_2[@@english_full[lang]]}" if rc == ISO639_1
        elsif @@french_full.has_key?(lang)
          return :"#{@@french_full[lang]}" if rc == ISO639_2
          return :"#{@@iso639_1[@@french_full[lang]]}" if rc == ISO639_2
        else
          not_found(lang)
        end
      end
      @@loaded = false
      # Get the languages from the dictionary.
      def self.get_languages
        return if @@loaded
        @@iso639_1 = {}; @@iso639_2 = {};
        @@english_full = {}; @@french_full = {}
        languages = IO.readlines(Treat.lib + '/treat/resources/languages.txt')
        languages.each do |language|
          iso639_2, iso639_1, english_desc, french_desc =
          language.split(',')
          @@iso639_1[iso639_1] = iso639_2
          @@iso639_2[iso639_2] = iso639_1
          unless english_desc.nil?
            english_desc.strip.downcase.split('|').each do |l|
              @@english_full[l.downcase.strip] = iso639_2
            end
          end
          unless french_desc.nil?
            french_desc.strip.downcase.split('|').each do |l|
              @@french_full[l.downcase.strip] = iso639_2
            end
          end
        end
        @@loaded = true
      end
    end
  end
end
