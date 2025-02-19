require "active_support/core_ext/enumerable"
require "active_support/core_ext/object/inclusion"
require "active_support/core_ext/string/access"
require "active_support/core_ext/string/inflections"
require "awesome_print"
require "base58"
require "digest"
require "dotenv/load"
require "dry-initializer"
require "indefinite_article"
require "pry"
require "remedy"
require "thor"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.setup

module StoryKey
  BITS_PER_ENTRY = 10
  DEFAULT_BITSIZE = 256
  FOOTER_BITSIZE = 4 # StoryKey::BITS_PER_ENTRY must be lte 2^StoryKey::FOOTER_BITSIZE
  FORMATS = %i[base58 hex bin dec].freeze
  GRAMMAR = {
    4 => %i[adjective noun verb noun],
    3 => %i[noun verb noun],
    2 => %i[adjective noun],
    1 => %i[noun]
  }.freeze
  LEXICON_SHA_SIZE = 7
  MAX_BITSIZE = 512
  PREPOSITIONS = %w[in i saw and a an].freeze
  GITHUB_URL = "https://github.com/jcraigk/storykey"

  Entry = Struct.new(:part_of_speech, :raw, :token, :text, :countable, :preposition)
  Story = Struct.new(:phrases, :text, :humanized, :tokenized)

  class Error < StandardError; end
  class InvalidFormat < Error; end
  class InvalidVersion < Error; end
  class InvalidWord < Error; end
  class InvalidChecksum < Error; end
  class KeyTooLarge < Error; end
end

loader.eager_load
