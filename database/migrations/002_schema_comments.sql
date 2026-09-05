-- Human-readable PostgreSQL metadata for the Sollu schema.
-- Foreign-key columns describe their parent relationship in their column comments.

COMMENT ON TABLE users IS 'Application accounts. Referenced by roles, vocabulary audit fields, favorites, learning records, and quiz ownership.';
COMMENT ON COLUMN users.id IS 'Stable unique identifier for the user.';
COMMENT ON COLUMN users.email IS 'Unique login email address.';
COMMENT ON COLUMN users.password_hash IS 'Server-side password hash. Never store or expose a plain-text password.';
COMMENT ON COLUMN users.display_name IS 'Optional name shown in the application.';
COMMENT ON COLUMN users.created_at IS 'Time when the account was created.';
COMMENT ON COLUMN users.updated_at IS 'Time when the account was last changed.';

COMMENT ON TABLE roles IS 'Named authorization roles assigned to users through user_roles.';
COMMENT ON COLUMN roles.id IS 'Stable unique identifier for the role.';
COMMENT ON COLUMN roles.name IS 'Unique role name, such as admin or editor.';
COMMENT ON COLUMN roles.created_at IS 'Time when the role was created.';

COMMENT ON TABLE permissions IS 'Atomic capabilities granted to roles through role_permissions.';
COMMENT ON COLUMN permissions.id IS 'Stable unique identifier for the permission.';
COMMENT ON COLUMN permissions.name IS 'Unique permission name.';
COMMENT ON COLUMN permissions.created_at IS 'Time when the permission was created.';

COMMENT ON TABLE user_roles IS 'Many-to-many relationship between users and roles.';
COMMENT ON COLUMN user_roles.user_id IS 'User receiving the role; references users.id.';
COMMENT ON COLUMN user_roles.role_id IS 'Role assigned to the user; references roles.id.';

COMMENT ON TABLE role_permissions IS 'Many-to-many relationship between roles and permissions.';
COMMENT ON COLUMN role_permissions.role_id IS 'Role receiving the permission; references roles.id.';
COMMENT ON COLUMN role_permissions.permission_id IS 'Permission granted to the role; references permissions.id.';

COMMENT ON TABLE categories IS 'Vocabulary categories used to group words.';
COMMENT ON COLUMN categories.id IS 'Stable unique identifier for the category.';
COMMENT ON COLUMN categories.name IS 'Human-readable category name.';
COMMENT ON COLUMN categories.slug IS 'Unique URL-safe category identifier.';
COMMENT ON COLUMN categories.description IS 'Optional explanation of the category.';
COMMENT ON COLUMN categories.created_at IS 'Time when the category was created.';
COMMENT ON COLUMN categories.updated_at IS 'Time when the category was last changed.';

COMMENT ON TABLE words IS 'Root vocabulary records. All word-related content references words.id.';
COMMENT ON COLUMN words.id IS 'Stable unique identifier for the vocabulary word.';
COMMENT ON COLUMN words.word IS 'Canonical English vocabulary word.';
COMMENT ON COLUMN words.slug IS 'Unique URL-safe identifier used by word detail routes.';
COMMENT ON COLUMN words.status IS 'Publishing lifecycle state: DRAFT, REVIEW, PUBLISHED, or ARCHIVED.';
COMMENT ON COLUMN words.created_by IS 'User who created the word; references users.id and is retained if the user is removed.';
COMMENT ON COLUMN words.updated_by IS 'User who last changed the word; references users.id and is retained if the user is removed.';
COMMENT ON COLUMN words.created_at IS 'Time when the word was created.';
COMMENT ON COLUMN words.updated_at IS 'Time when the word was last changed.';

COMMENT ON TABLE word_categories IS 'Many-to-many relationship between vocabulary words and categories.';
COMMENT ON COLUMN word_categories.word_id IS 'Categorized word; references words.id.';
COMMENT ON COLUMN word_categories.category_id IS 'Assigned category; references categories.id.';

COMMENT ON TABLE word_information IS 'General metadata for a word, including frequency and CEFR information.';
COMMENT ON COLUMN word_information.word_id IS 'Word described by this one-to-one record; references words.id.';
COMMENT ON COLUMN word_information.word_type IS 'Broad word classification, such as common.';
COMMENT ON COLUMN word_information.frequency IS 'Usage frequency classification.';
COMMENT ON COLUMN word_information.cefr_level IS 'Optional Common European Framework level.';
COMMENT ON COLUMN word_information.created_at IS 'Time when the metadata was created.';
COMMENT ON COLUMN word_information.updated_at IS 'Time when the metadata was last changed.';

COMMENT ON TABLE word_information_registers IS 'Register values attached to word information, such as formal or spoken.';
COMMENT ON COLUMN word_information_registers.word_id IS 'Word metadata record; references word_information.word_id.';
COMMENT ON COLUMN word_information_registers.register IS 'Communication register classification.';

COMMENT ON TABLE pronunciations IS 'Pronunciation metadata for a word.';
COMMENT ON COLUMN pronunciations.word_id IS 'Word being pronounced; references words.id.';
COMMENT ON COLUMN pronunciations.ipa IS 'International Phonetic Alphabet pronunciation.';
COMMENT ON COLUMN pronunciations.phonetic IS 'Readable phonetic pronunciation guide.';
COMMENT ON COLUMN pronunciations.syllables IS 'Number of syllables in the word.';
COMMENT ON COLUMN pronunciations.stress IS 'Description of the stressed syllable.';

COMMENT ON TABLE pronunciation_audio IS 'UK and US audio references for a pronunciation.';
COMMENT ON COLUMN pronunciation_audio.word_id IS 'Pronunciation record; references pronunciations.word_id.';
COMMENT ON COLUMN pronunciation_audio.uk_url IS 'URL for UK pronunciation audio.';
COMMENT ON COLUMN pronunciation_audio.us_url IS 'URL for US pronunciation audio.';

COMMENT ON TABLE meanings IS 'Individual definitions for a word. A word can have multiple meanings.';
COMMENT ON COLUMN meanings.id IS 'Stable unique identifier for the meaning.';
COMMENT ON COLUMN meanings.word_id IS 'Word owning the meaning; references words.id.';
COMMENT ON COLUMN meanings.definition IS 'Full English definition.';
COMMENT ON COLUMN meanings.simple_explanation IS 'Plain-English explanation for learners.';
COMMENT ON COLUMN meanings.meaning_order IS 'Display order of this meaning for its word.';

COMMENT ON TABLE meaning_tamil IS 'Tamil translations belonging to an individual meaning.';
COMMENT ON COLUMN meaning_tamil.id IS 'Stable unique identifier for the Tamil translation.';
COMMENT ON COLUMN meaning_tamil.meaning_id IS 'Meaning being translated; references meanings.id.';
COMMENT ON COLUMN meaning_tamil.translation IS 'Tamil translation stored as Unicode text.';
COMMENT ON COLUMN meaning_tamil.translation_order IS 'Display order of the translation for its meaning.';

COMMENT ON TABLE meaning_grammar IS 'Grammar information belonging to one meaning rather than the whole word.';
COMMENT ON COLUMN meaning_grammar.meaning_id IS 'Meaning described by the grammar record; references meanings.id.';
COMMENT ON COLUMN meaning_grammar.part_of_speech IS 'Part of speech, such as noun, verb, or adjective.';
COMMENT ON COLUMN meaning_grammar.countability IS 'Countability information for nouns when applicable.';
COMMENT ON COLUMN meaning_grammar.usage IS 'Grammar-specific usage guidance.';
COMMENT ON COLUMN meaning_grammar.transitivity IS 'Verb transitivity information when applicable.';

COMMENT ON TABLE verb_forms IS 'Inflected verb forms for a meaning whose part of speech is a verb.';
COMMENT ON COLUMN verb_forms.meaning_id IS 'Grammar record containing the verb; references meaning_grammar.meaning_id.';
COMMENT ON COLUMN verb_forms.base_form IS 'Base or infinitive form.';
COMMENT ON COLUMN verb_forms.third_person_singular IS 'Third-person singular present form.';
COMMENT ON COLUMN verb_forms.present_participle IS 'Present participle or -ing form.';
COMMENT ON COLUMN verb_forms.past_tense IS 'Simple past form.';
COMMENT ON COLUMN verb_forms.past_participle IS 'Past participle form.';

COMMENT ON TABLE sentence_patterns IS 'Reusable sentence patterns associated with meaning grammar.';
COMMENT ON COLUMN sentence_patterns.id IS 'Stable unique identifier for the pattern.';
COMMENT ON COLUMN sentence_patterns.meaning_id IS 'Grammar record owning the pattern; references meaning_grammar.meaning_id.';
COMMENT ON COLUMN sentence_patterns.pattern IS 'Natural sentence pattern using the vocabulary word.';
COMMENT ON COLUMN sentence_patterns.pattern_order IS 'Display order of the pattern.';

COMMENT ON TABLE common_prepositions IS 'Prepositions commonly used with a meaning.';
COMMENT ON COLUMN common_prepositions.id IS 'Stable unique identifier for the preposition record.';
COMMENT ON COLUMN common_prepositions.meaning_id IS 'Grammar record owning the preposition; references meaning_grammar.meaning_id.';
COMMENT ON COLUMN common_prepositions.preposition IS 'Commonly associated preposition.';

COMMENT ON TABLE meaning_examples IS 'English and Tamil example sentences for a meaning.';
COMMENT ON COLUMN meaning_examples.id IS 'Stable unique identifier for the example.';
COMMENT ON COLUMN meaning_examples.meaning_id IS 'Meaning demonstrated by the example; references meanings.id.';
COMMENT ON COLUMN meaning_examples.english IS 'Natural English example sentence.';
COMMENT ON COLUMN meaning_examples.tamil IS 'Tamil translation of the example.';
COMMENT ON COLUMN meaning_examples.example_order IS 'Display order of the example.';

COMMENT ON TABLE synonyms IS 'Related words that share a similar meaning, scoped to a meaning.';
COMMENT ON COLUMN synonyms.id IS 'Stable unique identifier for the synonym record.';
COMMENT ON COLUMN synonyms.meaning_id IS 'Meaning for which this synonym is relevant; references meanings.id.';
COMMENT ON COLUMN synonyms.word IS 'Synonym word.';
COMMENT ON COLUMN synonyms.meaning IS 'Meaning of the synonym.';
COMMENT ON COLUMN synonyms.tamil IS 'Tamil translation of the synonym.';
COMMENT ON COLUMN synonyms.usage_difference IS 'Explanation of how usage differs from the source word.';

COMMENT ON TABLE antonyms IS 'Contrasting words, scoped to a meaning.';
COMMENT ON COLUMN antonyms.id IS 'Stable unique identifier for the antonym record.';
COMMENT ON COLUMN antonyms.meaning_id IS 'Meaning for which this antonym is relevant; references meanings.id.';
COMMENT ON COLUMN antonyms.word IS 'Antonym word.';
COMMENT ON COLUMN antonyms.meaning IS 'Meaning of the antonym.';
COMMENT ON COLUMN antonyms.tamil IS 'Tamil translation of the antonym.';
COMMENT ON COLUMN antonyms.usage_difference IS 'Explanation of how usage differs from the source word.';

COMMENT ON TABLE word_images IS 'Context and learning images associated with a word.';
COMMENT ON COLUMN word_images.id IS 'Stable unique identifier for the image record.';
COMMENT ON COLUMN word_images.word_id IS 'Word illustrated by the image; references words.id.';
COMMENT ON COLUMN word_images.type IS 'Purpose of the image, such as context or illustration.';
COMMENT ON COLUMN word_images.url IS 'Original image URL supplied by the API.';
COMMENT ON COLUMN word_images.thumbnail_url IS 'Optional smaller image URL.';
COMMENT ON COLUMN word_images.source_url IS 'Original source or attribution URL.';
COMMENT ON COLUMN word_images.provider IS 'Image provider name.';
COMMENT ON COLUMN word_images.title IS 'Human-readable image title.';
COMMENT ON COLUMN word_images.description IS 'Description of the image content.';
COMMENT ON COLUMN word_images.alt_text IS 'Required accessible alternative text.';
COMMENT ON COLUMN word_images.creator IS 'Image creator or photographer.';
COMMENT ON COLUMN word_images.license_name IS 'Image license name.';
COMMENT ON COLUMN word_images.license_url IS 'URL describing the image license.';
COMMENT ON COLUMN word_images.credit IS 'Attribution text to display.';
COMMENT ON COLUMN word_images.is_primary IS 'Whether this is the primary image for the word.';

COMMENT ON TABLE word_forms IS 'Related grammatical forms grouped by category.';
COMMENT ON COLUMN word_forms.id IS 'Stable unique identifier for the word form.';
COMMENT ON COLUMN word_forms.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN word_forms.form IS 'Related noun, verb, adjective, or adverb form.';
COMMENT ON COLUMN word_forms.grammatical_category IS 'Category of the related form.';

COMMENT ON TABLE collocations IS 'Words that naturally occur together with the source word.';
COMMENT ON COLUMN collocations.id IS 'Stable unique identifier for the collocation.';
COMMENT ON COLUMN collocations.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN collocations.collocation IS 'Natural word combination.';
COMMENT ON COLUMN collocations.meaning IS 'Meaning of the collocation.';
COMMENT ON COLUMN collocations.tamil IS 'Tamil translation of the collocation.';

COMMENT ON TABLE collocation_examples IS 'Example sentences for a collocation.';
COMMENT ON COLUMN collocation_examples.id IS 'Stable unique identifier for the example.';
COMMENT ON COLUMN collocation_examples.collocation_id IS 'Collocation demonstrated by the example; references collocations.id.';
COMMENT ON COLUMN collocation_examples.english IS 'English example sentence.';
COMMENT ON COLUMN collocation_examples.tamil IS 'Tamil translation of the example.';

COMMENT ON TABLE phrases IS 'Common phrases that use the source word.';
COMMENT ON COLUMN phrases.id IS 'Stable unique identifier for the phrase.';
COMMENT ON COLUMN phrases.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN phrases.phrase IS 'Common phrase containing the word.';
COMMENT ON COLUMN phrases.meaning IS 'Meaning of the phrase.';
COMMENT ON COLUMN phrases.tamil IS 'Tamil translation of the phrase.';
COMMENT ON COLUMN phrases.usage IS 'Guidance about when the phrase is used.';

COMMENT ON TABLE phrase_examples IS 'Example sentences for a phrase.';
COMMENT ON COLUMN phrase_examples.id IS 'Stable unique identifier for the example.';
COMMENT ON COLUMN phrase_examples.phrase_id IS 'Phrase demonstrated by the example; references phrases.id.';
COMMENT ON COLUMN phrase_examples.english IS 'English example sentence.';
COMMENT ON COLUMN phrase_examples.tamil IS 'Tamil translation of the example.';

COMMENT ON TABLE phrasal_verbs IS 'Phrasal verbs related to the source word when applicable.';
COMMENT ON COLUMN phrasal_verbs.id IS 'Stable unique identifier for the phrasal verb.';
COMMENT ON COLUMN phrasal_verbs.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN phrasal_verbs.verb IS 'Phrasal verb expression.';
COMMENT ON COLUMN phrasal_verbs.meaning IS 'Meaning of the phrasal verb.';
COMMENT ON COLUMN phrasal_verbs.tamil IS 'Tamil translation of the phrasal verb.';
COMMENT ON COLUMN phrasal_verbs.usage IS 'Guidance about when the phrasal verb is used.';

COMMENT ON TABLE phrasal_verb_examples IS 'Example sentences for a phrasal verb.';
COMMENT ON COLUMN phrasal_verb_examples.id IS 'Stable unique identifier for the example.';
COMMENT ON COLUMN phrasal_verb_examples.phrasal_verb_id IS 'Phrasal verb demonstrated by the example; references phrasal_verbs.id.';
COMMENT ON COLUMN phrasal_verb_examples.english IS 'English example sentence.';
COMMENT ON COLUMN phrasal_verb_examples.tamil IS 'Tamil translation of the example.';

COMMENT ON TABLE idioms IS 'Idiomatic expressions related to the source word when applicable.';
COMMENT ON COLUMN idioms.id IS 'Stable unique identifier for the idiom.';
COMMENT ON COLUMN idioms.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN idioms.idiom IS 'Idiom expression.';
COMMENT ON COLUMN idioms.meaning IS 'Meaning of the idiom.';
COMMENT ON COLUMN idioms.tamil IS 'Tamil explanation or translation of the idiom.';
COMMENT ON COLUMN idioms.usage IS 'Guidance about when the idiom is used.';

COMMENT ON TABLE idiom_examples IS 'Example sentences for an idiom.';
COMMENT ON COLUMN idiom_examples.id IS 'Stable unique identifier for the example.';
COMMENT ON COLUMN idiom_examples.idiom_id IS 'Idiom demonstrated by the example; references idioms.id.';
COMMENT ON COLUMN idiom_examples.english IS 'English example sentence.';
COMMENT ON COLUMN idiom_examples.tamil IS 'Tamil translation of the example.';

COMMENT ON TABLE usage IS 'General usage guidance for a word.';
COMMENT ON COLUMN usage.word_id IS 'Word described by this one-to-one usage record; references words.id.';
COMMENT ON COLUMN usage.when_to_use IS 'General explanation of when to use the word.';

COMMENT ON TABLE usage_examples IS 'Examples grouped by formal, informal, spoken, or written usage.';
COMMENT ON COLUMN usage_examples.id IS 'Stable unique identifier for the usage example.';
COMMENT ON COLUMN usage_examples.word_id IS 'Word whose usage is demonstrated; references usage.word_id.';
COMMENT ON COLUMN usage_examples.usage_type IS 'Usage context: formal, informal, spoken, or written.';
COMMENT ON COLUMN usage_examples.english IS 'English usage example.';
COMMENT ON COLUMN usage_examples.tamil IS 'Tamil translation of the usage example.';

COMMENT ON TABLE common_mistakes IS 'Incorrect and corrected examples that teach common usage mistakes.';
COMMENT ON COLUMN common_mistakes.id IS 'Stable unique identifier for the mistake.';
COMMENT ON COLUMN common_mistakes.word_id IS 'Word associated with the mistake; references words.id.';
COMMENT ON COLUMN common_mistakes.incorrect IS 'Incorrect sentence or usage.';
COMMENT ON COLUMN common_mistakes.correct IS 'Correct sentence or usage.';
COMMENT ON COLUMN common_mistakes.explanation IS 'Explanation of the correction.';

COMMENT ON TABLE conversation_examples IS 'Conversation scenarios demonstrating a word in context.';
COMMENT ON COLUMN conversation_examples.id IS 'Stable unique identifier for the conversation.';
COMMENT ON COLUMN conversation_examples.word_id IS 'Word demonstrated by the conversation; references words.id.';
COMMENT ON COLUMN conversation_examples.situation IS 'Situation or context for the conversation.';

COMMENT ON TABLE conversation_lines IS 'Ordered speaker lines belonging to a conversation example.';
COMMENT ON COLUMN conversation_lines.id IS 'Stable unique identifier for the conversation line.';
COMMENT ON COLUMN conversation_lines.conversation_id IS 'Conversation containing the line; references conversation_examples.id.';
COMMENT ON COLUMN conversation_lines.speaker IS 'Speaker label, such as A or B.';
COMMENT ON COLUMN conversation_lines.english IS 'English line spoken by the speaker.';
COMMENT ON COLUMN conversation_lines.tamil IS 'Tamil translation of the line.';
COMMENT ON COLUMN conversation_lines.line_order IS 'Display order within the conversation.';

COMMENT ON TABLE commonly_confused_words IS 'Words commonly confused with the source word and their differences.';
COMMENT ON COLUMN commonly_confused_words.id IS 'Stable unique identifier for the comparison.';
COMMENT ON COLUMN commonly_confused_words.word_id IS 'Source word; references words.id.';
COMMENT ON COLUMN commonly_confused_words.related_word IS 'Word commonly confused with the source word.';
COMMENT ON COLUMN commonly_confused_words.difference IS 'Explanation of the difference between the words.';

COMMENT ON TABLE memory_tips IS 'English and Tamil memory aids for a word.';
COMMENT ON COLUMN memory_tips.word_id IS 'Word remembered by this one-to-one record; references words.id.';
COMMENT ON COLUMN memory_tips.english IS 'English memory tip.';
COMMENT ON COLUMN memory_tips.tamil IS 'Tamil memory tip.';

COMMENT ON TABLE favorites IS 'Words saved by users for later learning.';
COMMENT ON COLUMN favorites.user_id IS 'User who saved the word; references users.id.';
COMMENT ON COLUMN favorites.word_id IS 'Saved vocabulary word; references words.id.';
COMMENT ON COLUMN favorites.created_at IS 'Time when the favorite was created.';

COMMENT ON TABLE learning_progress IS 'Current learning state for each user and word pair.';
COMMENT ON COLUMN learning_progress.user_id IS 'Learner; references users.id.';
COMMENT ON COLUMN learning_progress.word_id IS 'Word being learned; references words.id.';
COMMENT ON COLUMN learning_progress.status IS 'Learning state: NOT_STARTED, IN_PROGRESS, or MASTERED.';
COMMENT ON COLUMN learning_progress.score IS 'Latest or current learning score from 0 to 100.';
COMMENT ON COLUMN learning_progress.last_reviewed_at IS 'Time when the word was most recently reviewed.';
COMMENT ON COLUMN learning_progress.updated_at IS 'Time when progress was last changed.';

COMMENT ON TABLE learning_history IS 'Append-only record of learning activities for users and words.';
COMMENT ON COLUMN learning_history.id IS 'Stable unique identifier for the learning event.';
COMMENT ON COLUMN learning_history.user_id IS 'Learner performing the action; references users.id.';
COMMENT ON COLUMN learning_history.word_id IS 'Word involved in the action; references words.id.';
COMMENT ON COLUMN learning_history.action IS 'Learning action performed.';
COMMENT ON COLUMN learning_history.score IS 'Optional score for the learning event from 0 to 100.';
COMMENT ON COLUMN learning_history.created_at IS 'Time when the learning event occurred.';

COMMENT ON TABLE quizzes IS 'Quiz definitions created for vocabulary learning.';
COMMENT ON COLUMN quizzes.id IS 'Stable unique identifier for the quiz.';
COMMENT ON COLUMN quizzes.title IS 'Quiz title.';
COMMENT ON COLUMN quizzes.description IS 'Optional quiz description.';
COMMENT ON COLUMN quizzes.is_published IS 'Whether the quiz is available to learners.';
COMMENT ON COLUMN quizzes.created_by IS 'User who created the quiz; references users.id and is retained if removed.';
COMMENT ON COLUMN quizzes.created_at IS 'Time when the quiz was created.';
COMMENT ON COLUMN quizzes.updated_at IS 'Time when the quiz was last changed.';

COMMENT ON TABLE quiz_questions IS 'Questions belonging to a quiz, optionally linked to a vocabulary word.';
COMMENT ON COLUMN quiz_questions.id IS 'Stable unique identifier for the question.';
COMMENT ON COLUMN quiz_questions.quiz_id IS 'Quiz containing the question; references quizzes.id.';
COMMENT ON COLUMN quiz_questions.word_id IS 'Optional vocabulary word tested by the question; references words.id.';
COMMENT ON COLUMN quiz_questions.question IS 'Question text shown to the learner.';
COMMENT ON COLUMN quiz_questions.question_order IS 'Display order within the quiz.';

COMMENT ON TABLE quiz_answers IS 'Possible answers belonging to a quiz question.';
COMMENT ON COLUMN quiz_answers.id IS 'Stable unique identifier for the answer.';
COMMENT ON COLUMN quiz_answers.question_id IS 'Question containing the answer; references quiz_questions.id.';
COMMENT ON COLUMN quiz_answers.answer IS 'Answer text shown to the learner.';
COMMENT ON COLUMN quiz_answers.is_correct IS 'Whether the answer is correct.';
COMMENT ON COLUMN quiz_answers.answer_order IS 'Display order for answers to the question.';
