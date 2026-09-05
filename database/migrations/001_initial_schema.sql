CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TYPE vocabulary_status AS ENUM ('DRAFT', 'REVIEW', 'PUBLISHED', 'ARCHIVED');
CREATE TYPE register_type AS ENUM ('neutral', 'formal', 'informal', 'technical', 'academic', 'literary', 'spoken');
CREATE TYPE image_type AS ENUM ('context', 'illustration', 'diagram');
CREATE TYPE progress_status AS ENUM ('NOT_STARTED', 'IN_PROGRESS', 'MASTERED');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  display_name TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE roles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_roles (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE role_permissions (
  role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
  permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
  PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL UNIQUE,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE words (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  status vocabulary_status NOT NULL DEFAULT 'DRAFT',
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  updated_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT words_word_unique UNIQUE (word)
);

CREATE TABLE word_categories (
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  category_id UUID NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  PRIMARY KEY (word_id, category_id)
);

CREATE TABLE word_information (
  word_id UUID PRIMARY KEY REFERENCES words(id) ON DELETE CASCADE,
  word_type TEXT NOT NULL,
  frequency TEXT NOT NULL,
  cefr_level TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE word_information_registers (
  word_id UUID NOT NULL REFERENCES word_information(word_id) ON DELETE CASCADE,
  register register_type NOT NULL,
  PRIMARY KEY (word_id, register)
);

CREATE TABLE pronunciations (
  word_id UUID PRIMARY KEY REFERENCES words(id) ON DELETE CASCADE,
  ipa TEXT,
  phonetic TEXT,
  syllables SMALLINT CHECK (syllables IS NULL OR syllables > 0),
  stress TEXT
);

CREATE TABLE pronunciation_audio (
  word_id UUID PRIMARY KEY REFERENCES pronunciations(word_id) ON DELETE CASCADE,
  uk_url TEXT,
  us_url TEXT
);

CREATE TABLE meanings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  definition TEXT NOT NULL,
  simple_explanation TEXT NOT NULL,
  meaning_order INTEGER NOT NULL DEFAULT 0 CHECK (meaning_order >= 0),
  UNIQUE (word_id, meaning_order)
);

CREATE TABLE meaning_tamil (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meanings(id) ON DELETE CASCADE,
  translation TEXT NOT NULL,
  translation_order INTEGER NOT NULL DEFAULT 0 CHECK (translation_order >= 0),
  UNIQUE (meaning_id, translation_order)
);

CREATE TABLE meaning_grammar (
  meaning_id UUID PRIMARY KEY REFERENCES meanings(id) ON DELETE CASCADE,
  part_of_speech TEXT NOT NULL,
  countability TEXT,
  usage TEXT,
  transitivity TEXT
);

CREATE TABLE verb_forms (
  meaning_id UUID PRIMARY KEY REFERENCES meaning_grammar(meaning_id) ON DELETE CASCADE,
  base_form TEXT,
  third_person_singular TEXT,
  present_participle TEXT,
  past_tense TEXT,
  past_participle TEXT
);

CREATE TABLE sentence_patterns (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meaning_grammar(meaning_id) ON DELETE CASCADE,
  pattern TEXT NOT NULL,
  pattern_order INTEGER NOT NULL DEFAULT 0 CHECK (pattern_order >= 0),
  UNIQUE (meaning_id, pattern)
);

CREATE TABLE common_prepositions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meaning_grammar(meaning_id) ON DELETE CASCADE,
  preposition TEXT NOT NULL,
  UNIQUE (meaning_id, preposition)
);

CREATE TABLE meaning_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meanings(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL,
  example_order INTEGER NOT NULL DEFAULT 0 CHECK (example_order >= 0)
);

CREATE TABLE synonyms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meanings(id) ON DELETE CASCADE,
  word TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  usage_difference TEXT NOT NULL
);

CREATE TABLE antonyms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  meaning_id UUID NOT NULL REFERENCES meanings(id) ON DELETE CASCADE,
  word TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  usage_difference TEXT NOT NULL
);

CREATE TABLE word_images (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  type image_type NOT NULL DEFAULT 'context',
  url TEXT,
  thumbnail_url TEXT,
  source_url TEXT,
  provider TEXT,
  title TEXT,
  description TEXT,
  alt_text TEXT NOT NULL,
  creator TEXT,
  license_name TEXT,
  license_url TEXT,
  credit TEXT,
  is_primary BOOLEAN NOT NULL DEFAULT false
);

CREATE UNIQUE INDEX one_primary_image_per_word
  ON word_images (word_id)
  WHERE is_primary;

CREATE TABLE word_forms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  form TEXT NOT NULL,
  grammatical_category TEXT NOT NULL CHECK (grammatical_category IN ('noun', 'verb', 'adjective', 'adverb')),
  UNIQUE (word_id, form, grammatical_category)
);

CREATE TABLE collocations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  collocation TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  UNIQUE (word_id, collocation)
);

CREATE TABLE collocation_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  collocation_id UUID NOT NULL REFERENCES collocations(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL
);

CREATE TABLE phrases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  phrase TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  usage TEXT NOT NULL,
  UNIQUE (word_id, phrase)
);

CREATE TABLE phrase_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phrase_id UUID NOT NULL REFERENCES phrases(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL
);

CREATE TABLE phrasal_verbs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  verb TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  usage TEXT NOT NULL,
  UNIQUE (word_id, verb)
);

CREATE TABLE phrasal_verb_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phrasal_verb_id UUID NOT NULL REFERENCES phrasal_verbs(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL
);

CREATE TABLE idioms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  idiom TEXT NOT NULL,
  meaning TEXT NOT NULL,
  tamil TEXT NOT NULL,
  usage TEXT NOT NULL,
  UNIQUE (word_id, idiom)
);

CREATE TABLE idiom_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  idiom_id UUID NOT NULL REFERENCES idioms(id) ON DELETE CASCADE,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL
);

CREATE TABLE usage (
  word_id UUID PRIMARY KEY REFERENCES words(id) ON DELETE CASCADE,
  when_to_use TEXT NOT NULL DEFAULT ''
);

CREATE TABLE usage_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES usage(word_id) ON DELETE CASCADE,
  usage_type TEXT NOT NULL CHECK (usage_type IN ('formal', 'informal', 'spoken', 'written')),
  english TEXT NOT NULL,
  tamil TEXT NOT NULL
);

CREATE TABLE common_mistakes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  incorrect TEXT NOT NULL,
  correct TEXT NOT NULL,
  explanation TEXT NOT NULL
);

CREATE TABLE conversation_examples (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  situation TEXT NOT NULL
);

CREATE TABLE conversation_lines (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id UUID NOT NULL REFERENCES conversation_examples(id) ON DELETE CASCADE,
  speaker TEXT NOT NULL,
  english TEXT NOT NULL,
  tamil TEXT NOT NULL,
  line_order INTEGER NOT NULL DEFAULT 0 CHECK (line_order >= 0),
  UNIQUE (conversation_id, line_order)
);

CREATE TABLE commonly_confused_words (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  related_word TEXT NOT NULL,
  difference TEXT NOT NULL,
  UNIQUE (word_id, related_word)
);

CREATE TABLE memory_tips (
  word_id UUID PRIMARY KEY REFERENCES words(id) ON DELETE CASCADE,
  english TEXT NOT NULL DEFAULT '',
  tamil TEXT NOT NULL DEFAULT ''
);

CREATE TABLE favorites (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, word_id)
);

CREATE TABLE learning_progress (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  status progress_status NOT NULL DEFAULT 'NOT_STARTED',
  score NUMERIC(5, 2) CHECK (score IS NULL OR (score >= 0 AND score <= 100)),
  last_reviewed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, word_id)
);

CREATE TABLE learning_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  word_id UUID NOT NULL REFERENCES words(id) ON DELETE CASCADE,
  action TEXT NOT NULL,
  score NUMERIC(5, 2) CHECK (score IS NULL OR (score >= 0 AND score <= 100)),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE quizzes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  description TEXT,
  is_published BOOLEAN NOT NULL DEFAULT false,
  created_by UUID REFERENCES users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE quiz_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id UUID NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  word_id UUID REFERENCES words(id) ON DELETE SET NULL,
  question TEXT NOT NULL,
  question_order INTEGER NOT NULL CHECK (question_order >= 0),
  UNIQUE (quiz_id, question_order)
);

CREATE TABLE quiz_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES quiz_questions(id) ON DELETE CASCADE,
  answer TEXT NOT NULL,
  is_correct BOOLEAN NOT NULL DEFAULT false,
  answer_order INTEGER NOT NULL CHECK (answer_order >= 0),
  UNIQUE (question_id, answer_order)
);

CREATE INDEX words_status_idx ON words (status);
CREATE INDEX words_word_search_idx ON words (word);
CREATE INDEX meanings_word_id_idx ON meanings (word_id);
CREATE INDEX meaning_tamil_translation_idx ON meaning_tamil (translation);
CREATE INDEX word_images_word_id_idx ON word_images (word_id);
CREATE INDEX favorites_word_id_idx ON favorites (word_id);
CREATE INDEX learning_progress_user_id_idx ON learning_progress (user_id);
CREATE INDEX learning_history_user_id_created_at_idx ON learning_history (user_id, created_at DESC);
CREATE INDEX quiz_questions_quiz_id_idx ON quiz_questions (quiz_id);
