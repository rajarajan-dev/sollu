# Sollu Copilot Instructions

Sollu is an English-Tamil vocabulary learning application. It provides English vocabulary, Tamil meanings, definitions, explanations, pronunciation, grammar, examples, related words, usage guidance, memory tips, images, quizzes, favorites, and learning progress.

## Architecture

Sollu consists of:

1. Web application (`apps/web`)
2. Mobile application (`apps/mobile`)
3. Backend API (`apps/api`)
4. PostgreSQL database
5. Admin application (planned)

The backend API is the source of truth for application data. Web, mobile, and admin clients must communicate through the API and must never connect directly to PostgreSQL.

The repository is a pnpm 11.14.0 and Turborepo monorepo using Node.js 22 or newer:

```text
apps/
  api/
  web/
  mobile/
  admin/             # planned

packages/
  config/
  shared/
  ui/

database/            # migrations, seeds, and scripts when introduced

docs/                # architecture, API, and database documentation
```

Preserve existing package boundaries and TypeScript configuration. Prefer the repository's existing components, services, utilities, types, and naming conventions.

## Commands

Run commands from the repository root unless a package-specific command is needed:

```bash
pnpm install
pnpm dev
pnpm build
pnpm lint
pnpm type-check
pnpm format:check
```

Use filters for individual projects:

```bash
pnpm --filter @sollu/api <command>
pnpm --filter @repo/web <command>
pnpm --filter @repo/mobile <command>
```

Run the narrowest relevant type-check, lint, or build after editing. Do not commit generated output, dependencies, or local environment files.

## Database and Environment

Sollu uses PostgreSQL.

Local development configuration:

```text
Host:     localhost
Port:     5432
Database: sollu
Username: myapp_user
Password: configured in environment variables
```

The application must use the `myapp_user` application database user and must not use the PostgreSQL `postgres` superuser from application code.

Example API environment configuration:

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=sollu
DB_USER=myapp_user
DB_PASSWORD=<LOCAL_DATABASE_PASSWORD>

DATABASE_URL=postgresql://myapp_user:<LOCAL_DATABASE_PASSWORD>@localhost:5432/sollu
```

The local PostgreSQL password is configured separately in the developer's `.env` file. Never put the real database password in source code, README files, Copilot instructions, client-side environment variables, or Git.

API environment files live in `apps/api/` and use Node's `--env-file` support. Web variables must use the `VITE_` prefix. Mobile variables must use the `EXPO_PUBLIC_` prefix.

Never expose database credentials, API secrets, JWT secrets, or other server-only values to web or mobile clients. Keep credential-bearing `.env` files ignored and update `.env.example` files when variables change.

Use migrations for all schema changes. Never manually alter the production schema.

The initial relational schema is defined in `database/migrations/001_initial_schema.sql`. Its table relationships are documented in `database/README.md`. Extend the migration system rather than creating ad hoc schema changes, and preserve the foreign-key relationships between words, meanings, learning data, users, and quizzes.

## Canonical Vocabulary Contract

The following logical structure is the canonical content contract for every database model, API DTO, validation schema, admin form, web screen, mobile screen, import, export, and seed.

Normalized PostgreSQL tables are acceptable, but the API must reconstruct this shape when returning a word.

```json
{
  "word": "communicate",

  "pronunciation": {
    "ipa": "/kəˈmjuːnɪkeɪt/",
    "phonetic": "kuh-MYOO-ni-kayt",
    "syllables": 4,
    "stress": "second syllable",
    "audio": {
      "uk": null,
      "us": null
    }
  },

  "word_information": {
    "word_type": "common",
    "frequency": "common",
    "cefr_level": "B1",
    "register": ["neutral", "formal"]
  },

  "meanings": [
    {
      "definition": "To share information, ideas, thoughts, or feelings with another person or group.",

      "simple_explanation": "To give information or express your thoughts so that another person understands you.",

      "tamil": ["தொடர்பு கொள்ளுதல்", "தகவலைப் பகிர்தல்", "கருத்துகளைத் தெரிவிக்குதல்"],

      "grammar": {
        "part_of_speech": "verb",
        "countability": null,
        "usage": "Used when talking about sharing information, ideas, thoughts, or feelings with other people.",

        "verb_forms": {
          "base_form": "communicate",
          "third_person_singular": "communicates",
          "present_participle": "communicating",
          "past_tense": "communicated",
          "past_participle": "communicated"
        },

        "transitivity": "transitive and intransitive",

        "common_prepositions": ["with", "to"],

        "sentence_patterns": [
          "communicate with someone",
          "communicate something to someone",
          "communicate effectively with someone",
          "communicate clearly with someone",
          "communicate something clearly",
          "communicate your thoughts",
          "communicate your feelings",
          "communicate your ideas"
        ]
      },

      "examples": [
        {
          "english": "It is important to communicate clearly with your team.",
          "tamil": "உங்கள் குழுவினருடன் தெளிவாகத் தொடர்புகொள்வது முக்கியம்."
        },
        {
          "english": "She communicated the problem to her manager.",
          "tamil": "அவர் பிரச்சினையை தனது மேலாளரிடம் தெரிவித்தார்."
        },
        {
          "english": "Good communication helps people understand each other.",
          "tamil": "நல்ல தொடர்பு மக்கள் ஒருவரையொருவர் புரிந்துகொள்ள உதவுகிறது."
        }
      ],

      "synonyms": [
        {
          "word": "express",
          "meaning": "To communicate a thought, feeling, or idea.",
          "tamil": "வெளிப்படுத்துதல்",
          "usage_difference": "Usually used for communicating thoughts, feelings, opinions, or ideas."
        },
        {
          "word": "convey",
          "meaning": "To communicate an idea, message, or feeling.",
          "tamil": "தெரிவித்தல் / எடுத்துரைத்தல்",
          "usage_difference": "More formal than communicate."
        },
        {
          "word": "inform",
          "meaning": "To give someone information about something.",
          "tamil": "தகவல் தெரிவித்தல்",
          "usage_difference": "Usually focuses on giving specific information to someone."
        }
      ],

      "antonyms": [
        {
          "word": "withhold",
          "meaning": "To deliberately keep information from someone.",
          "tamil": "தகவலை மறைத்தல்",
          "usage_difference": "Used when someone intentionally does not provide information."
        }
      ]
    }
  ],

  "images": [
    {
      "type": "context",
      "url": null,
      "thumbnail_url": null,
      "source_url": null,
      "provider": null,
      "title": "People communicating with each other",
      "description": "Two people sharing information or ideas through conversation.",
      "alt_text": "Two people communicating with each other",
      "creator": null,
      "license": {
        "name": null,
        "url": null
      },
      "credit": null,
      "is_primary": true
    }
  ],

  "word_forms": {
    "noun": ["communication", "communicator"],
    "verb": ["communicate"],
    "adjective": ["communicative"],
    "adverb": []
  },

  "collocations": [
    {
      "collocation": "effective communication",
      "meaning": "Communication that successfully conveys information or ideas.",
      "tamil": "திறமையான தொடர்பு",
      "example": {
        "english": "Effective communication is important in the workplace.",
        "tamil": "பணியிடத்தில் திறமையான தொடர்பு முக்கியமானது."
      }
    }
  ],

  "phrases": [
    {
      "phrase": "communicate with someone",
      "meaning": "To exchange information or ideas with someone.",
      "tamil": "ஒருவருடன் தொடர்புகொள்ளுதல்",
      "usage": "Used when describing communication between people.",
      "example": {
        "english": "I communicate with my colleagues every day.",
        "tamil": "நான் தினமும் எனது சக ஊழியர்களுடன் தொடர்புகொள்கிறேன்."
      }
    },
    {
      "phrase": "communicate effectively",
      "meaning": "To share information or ideas clearly and successfully.",
      "tamil": "திறம்படத் தொடர்புகொள்ளுதல்",
      "usage": "Commonly used when talking about communication skills.",
      "example": {
        "english": "Good leaders know how to communicate effectively.",
        "tamil": "நல்ல தலைவர்களுக்கு எவ்வாறு திறம்படத் தொடர்புகொள்வது என்பது தெரியும்."
      }
    },
    {
      "phrase": "communicate clearly",
      "meaning": "To express information or ideas in a way that is easy to understand.",
      "tamil": "தெளிவாகத் தொடர்புகொள்ளுதல்",
      "usage": "Used when emphasizing clear and understandable communication.",
      "example": {
        "english": "Please communicate clearly so everyone understands the plan.",
        "tamil": "அனைவரும் திட்டத்தைப் புரிந்துகொள்ளும் வகையில் தெளிவாகத் தெரிவிக்கவும்."
      }
    }
  ],

  "phrasal_verbs": [],

  "idioms": [],

  "usage": {
    "when_to_use": "Use this word when talking about sharing information, thoughts, ideas, feelings, or messages with other people.",

    "formal": [
      {
        "english": "The company communicated the changes to its employees.",
        "tamil": "நிறுவனம் மாற்றங்களை தனது ஊழியர்களுக்குத் தெரிவித்தது."
      }
    ],

    "informal": [
      {
        "english": "We need to communicate better.",
        "tamil": "நாம் இன்னும் சிறப்பாகத் தொடர்புகொள்ள வேண்டும்."
      }
    ],

    "spoken": [
      {
        "english": "I tried to communicate my concerns.",
        "tamil": "எனது கவலைகளைத் தெரிவிக்க நான் முயற்சி செய்தேன்."
      }
    ],

    "written": [
      {
        "english": "The organization communicated its decision in a formal letter.",
        "tamil": "நிறுவனம் தனது முடிவை ஒரு முறையான கடிதத்தின் மூலம் தெரிவித்தது."
      }
    ]
  },

  "common_mistakes": [
    {
      "incorrect": "I communicated him the problem.",
      "correct": "I communicated the problem to him.",
      "explanation": "When communicate is used with an object and a person, use 'communicate something to someone'."
    },
    {
      "incorrect": "I communicated with the information to him.",
      "correct": "I communicated the information to him.",
      "explanation": "Use 'communicate something to someone' when you are giving specific information. Do not use 'with' before the information."
    }
  ],

  "conversation_examples": [
    {
      "situation": "Workplace",
      "conversation": [
        {
          "speaker": "A",
          "english": "Have you communicated the changes to the team?",
          "tamil": "நீங்கள் மாற்றங்களை குழுவினருக்குத் தெரிவித்துவிட்டீர்களா?"
        },
        {
          "speaker": "B",
          "english": "Yes, I explained everything to them this morning.",
          "tamil": "ஆம், இன்று காலை அவர்களுக்கு எல்லாவற்றையும் விளக்கினேன்."
        }
      ]
    },
    {
      "situation": "Daily conversation",
      "conversation": [
        {
          "speaker": "A",
          "english": "Why didn't you tell him about the problem?",
          "tamil": "பிரச்சினையைப் பற்றி ஏன் அவரிடம் சொல்லவில்லை?"
        },
        {
          "speaker": "B",
          "english": "I tried to communicate with him, but he wasn't available.",
          "tamil": "நான் அவருடன் தொடர்புகொள்ள முயற்சி செய்தேன், ஆனால் அவர் கிடைக்கவில்லை."
        }
      ]
    }
  ],

  "commonly_confused_with": [
    {
      "word": "inform",
      "difference": "Inform usually means giving someone specific information, while communicate has a broader meaning and can include sharing ideas, feelings, thoughts, or information."
    },
    {
      "word": "communicate vs contact",
      "difference": "Contact usually means getting in touch with someone, while communicate focuses more on exchanging information, ideas, or feelings."
    }
  ],

  "memory_tip": {
    "english": "Communicate means sharing information, thoughts, ideas, or feelings so another person can understand.",
    "tamil": "மற்றவர் புரிந்துகொள்ளும் வகையில் தகவல், கருத்து அல்லது உணர்வுகளைப் பகிர்வது."
  }
}
```

### Vocabulary rules

- `word` must have a unique URL-safe slug, such as `/words/communicate`.
- `meanings` is always an array because one word can have multiple meanings.
- Grammar belongs to an individual meaning, not only to the word.
- Tamil meanings and examples are Unicode text; never transliterate Tamil into ASCII.
- Verb forms are included only when applicable.
- Synonyms and antonyms include their meaning, Tamil translation, and usage difference when available.
- Image records support `type`, `url`, `thumbnail_url`, `source_url`, `provider`, `title`, `description`, `alt_text`, `creator`, `license`, `credit`, and `is_primary`.
- `alt_text` is required for accessible images.
- Image URLs must come from the API, not hard-coded frontend components.
- Usage examples contain both `english` and `tamil`.
- Common mistakes contain `incorrect`, `correct`, and `explanation`.
- Conversation examples contain `situation` and conversation lines with `speaker`, `english`, and `tamil`.
- Commonly confused words contain `word` and `difference`.
- Vocabulary status values are `DRAFT`, `REVIEW`, `PUBLISHED`, and `ARCHIVED`.
- Public APIs normally expose only `PUBLISHED` records.
- `phrasal_verbs` and `idioms` may be empty arrays when not applicable.
- Do not invent phrasal verbs or idioms when they do not naturally apply to the word.

## Database Model

When database work is introduced, preserve relational integrity around these conceptual areas:

```text
users
roles
permissions

words
word_information
pronunciations
audio

meanings
meaning_tamil
meaning_grammar
verb_forms
sentence_patterns
meaning_examples
synonyms
antonyms

word_images
word_forms
collocations
phrases
phrasal_verbs
idioms

usage
usage_examples
common_mistakes

conversation_examples
conversation_lines

commonly_confused_words
memory_tips

categories

favorites
learning_progress
learning_history

quizzes
quiz_questions
quiz_answers
```

Shared vocabulary types belong in the shared package when the repository introduces them.

Keep property names aligned with the canonical contract, including:

```text
word_information
common_mistakes
conversation_examples
commonly_confused_with
```

## API Contract

The API base path is:

```text
/api/v1
```

Public endpoints should include:

```text
GET    /api/v1/words
GET    /api/v1/words/:id
GET    /api/v1/words/slug/:slug
GET    /api/v1/words/search?q=communicate

GET    /api/v1/categories
GET    /api/v1/categories/:id
```

Authentication endpoints:

```text
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
POST   /api/v1/auth/refresh
POST   /api/v1/auth/forgot-password
POST   /api/v1/auth/reset-password
```

Favorites:

```text
GET    /api/v1/favorites
POST   /api/v1/favorites/:wordId
DELETE /api/v1/favorites/:wordId
```

Learning:

```text
GET    /api/v1/learning
GET    /api/v1/progress
POST   /api/v1/progress
```

Quiz:

```text
GET    /api/v1/quizzes
GET    /api/v1/quizzes/:id
POST   /api/v1/quizzes/:id/submit
```

Admin vocabulary operations:

```text
GET    /api/v1/admin/words
POST   /api/v1/admin/words
GET    /api/v1/admin/words/:id
PATCH  /api/v1/admin/words/:id
DELETE /api/v1/admin/words/:id

POST   /api/v1/admin/words/:id/publish
POST   /api/v1/admin/words/:id/archive
```

Authentication and authorization must be applied to protected endpoints.

Admin endpoints must verify the required role/permission.

Prefer these response shapes:

```json
{
  "data": {},
  "meta": {}
}
```

Error response:

```json
{
  "error": {
    "code": "WORD_NOT_FOUND",
    "message": "The requested word was not found."
  }
}
```

Validate all vocabulary content on the backend.

Client validation improves UX but never replaces server validation.

Do not expose passwords, database credentials, SQL statements, stack traces, or internal secrets in API responses.

Search is implemented by the backend and may support:

```text
English words
Partial English words
Tamil meanings
Categories
Parts of speech
CEFR level
Frequency
Difficulty
```

Clients must not query PostgreSQL directly.

Use pagination rather than returning the entire vocabulary collection.

## Application Responsibilities

Web and mobile must consume the same API and must not maintain separate vocabulary databases.

### Web

Web screens include:

```text
Home
Search
Vocabulary List
Word Details
Categories
Favorites
Learning
Quiz
Progress
Profile
Settings
Login
Registration
```

Word Details should expose:

```text
Word
Pronunciation
Audio
IPA
Phonetic pronunciation
Syllables
Stress

Word Information

Tamil Meanings
English Definition
Simple Explanation

Grammar
Examples

Synonyms
Antonyms

Images
Word Forms

Collocations
Phrases
Phrasal Verbs
Idioms

Usage
Common Mistakes
Conversation Examples
Commonly Confused Words
Memory Tip
```

### Mobile

Mobile screens include:

```text
Splash
Onboarding
Login
Register
Home
Search
Vocabulary
Word Details
Categories
Favorites
Learning
Quiz
Progress
Profile
Settings
```

The mobile application consumes the same backend API as the web application.

### Admin

The planned admin application includes:

```text
Admin Dashboard

Vocabulary Management
Vocabulary Editor
Categories
Users
Quizzes
Reports
Roles
Permissions

Draft
Review
Publish
Archive

Import
```

The Add/Edit Vocabulary screen should map directly to the canonical vocabulary structure.

## Vocabulary Editor

The admin vocabulary editor should use sections:

```text
1. Basic Word
2. Pronunciation
3. Word Information
4. Meanings
5. Grammar
6. Examples
7. Synonyms
8. Antonyms
9. Images
10. Word Forms
11. Collocations
12. Phrases
13. Phrasal Verbs
14. Idioms
15. Usage
16. Common Mistakes
17. Conversation Examples
18. Commonly Confused Words
19. Memory Tip
20. Publishing
```

The editor must support multiple meanings.

Each meaning can independently contain:

```text
Definition
Simple Explanation
Tamil Meanings
Grammar
Examples
Synonyms
Antonyms
```

## Image Handling

Image metadata belongs to the vocabulary word through `images[]`.

Supported fields:

```text
type
url
thumbnail_url
source_url
provider
title
description
alt_text
creator
license
credit
is_primary
```

Images must be loaded from API data.

Do not hard-code image URLs inside UI components.

## Tamil Language Requirements

Tamil is a first-class language in Sollu.

Use UTF-8 throughout:

```text
PostgreSQL
API
Web
Mobile
Admin
```

Example Tamil text:

```text
தொடர்பு கொள்ளுதல்
தகவலைப் பகிர்தல்
கருத்துகளைத் தெரிவிக்குதல்
```

Do not transliterate Tamil into English.

Do not replace Tamil text with escaped ASCII representations when normal Unicode can be used.

## Database Migrations

All database schema changes must use migrations.

Example:

```text
database/
  migrations/
    001_create_users
    002_create_words
    003_create_meanings
    004_create_examples
    ...
```

Do not manually change the production database schema.

Every schema change must be represented by a migration.

## Seed Data

Seed data should be stored separately from migrations.

Example:

```text
database/
  seeds/
    categories
    parts_of_speech
    vocabulary
```

The `communicate` vocabulary record can be used as initial development seed data.

## Validation

Validate:

```text
word
pronunciation
word_information
meanings
Tamil meanings
grammar
examples
images
word_forms
collocations
phrases
phrasal_verbs
idioms
usage
common_mistakes
conversation_examples
commonly_confused_with
memory_tip
```

Backend validation is mandatory.

## Security

Never:

- Store plain-text user passwords.
- Commit database passwords.
- Commit API secrets.
- Expose JWT secrets.
- Expose database credentials to web/mobile clients.
- Allow web/mobile applications to connect directly to PostgreSQL.
- Return sensitive user information through public APIs.
- Log passwords, tokens, or secrets.

Use environment variables for server-side credentials.

## Quality and Accessibility

- Use UTF-8 throughout the entire system.
- Handle loading, error, and empty states.
- Maintain keyboard navigation.
- Support screen readers.
- Use semantic HTML.
- Provide accessible labels.
- Maintain visible focus states.
- Provide accessible buttons.
- Provide meaningful image `alt_text`.
- Maintain readable Tamil typography.
- Maintain responsive layouts.
- Add unit tests for important business logic.
- Add integration tests for API/database behavior.
- Add end-to-end tests for important user flows.
- Preserve existing functionality.
- Avoid unrelated refactors.
- Avoid unnecessary dependencies.

## Testing

### Unit Tests

Test:

```text
Vocabulary validation
Grammar validation
Search logic
Learning logic
Quiz logic
Authentication
Authorization
```

### Integration Tests

Test:

```text
API + PostgreSQL
Vocabulary CRUD
Search
Favorites
Progress
Authentication
Admin authorization
```

### End-to-End Tests

Important user flow:

```text
Register
  ↓
Login
  ↓
Search Word
  ↓
Open Word
  ↓
Read Tamil Meaning
  ↓
Favorite Word
```

Admin flow:

```text
Admin Login
  ↓
Create Word
  ↓
Save Draft
  ↓
Edit Word
  ↓
Review
  ↓
Publish
  ↓
Word becomes available publicly
```

## Development Rules

Before coding, inspect:

```text
package.json
apps/
packages/
database/
.env.example
tsconfig.json
```

Then:

1. Reuse existing components, services, types, and utilities.
2. Keep business logic in the backend.
3. Keep API contracts consistent.
4. Use strict TypeScript.
5. Validate API inputs.
6. Keep secrets in environment variables.
7. Never hard-code credentials.
8. Preserve the canonical vocabulary structure.
9. Use migrations for database schema changes.
10. Use seed data for development data.
11. Add tests for important behavior.
12. Maintain Tamil Unicode data.
13. Maintain accessibility.
14. Prefer small, maintainable modules.
15. Do not rewrite unrelated code.
16. Do not introduce dependencies without checking the existing repository first.
17. Do not connect web/mobile directly to PostgreSQL.
18. Do not change the canonical vocabulary field names without an explicit requirement.

## Important Copilot Instruction

When generating code for Sollu, treat this file as the project's architectural and vocabulary contract.

Before implementing a feature:

1. Inspect the existing repository.
2. Identify the existing architecture and package boundaries.
3. Reuse existing code where possible.
4. Check the canonical vocabulary structure.
5. Check the database/API contracts.
6. Implement the smallest maintainable change.
7. Validate the implementation.
8. Run the narrowest relevant tests, type-check, lint, and build.

Do not invent a different vocabulary structure.

Do not create a separate vocabulary model for web or mobile.

Do not expose PostgreSQL credentials to the client.

Do not bypass the backend API.

The PostgreSQL database is:

```text
Host:     localhost
Port:     5432
Database: sollu
Username: myapp_user
```

The PostgreSQL password is a local environment secret and must be read from `.env`.

## Definition of Done

A feature is complete when:

- The requirement is implemented.
- Existing architecture is respected.
- Database changes use migrations.
- Validation exists where required.
- Authorization exists where required.
- Relevant web/mobile/admin UI is implemented.
- Loading states are handled.
- Error states are handled.
- Empty states are handled.
- Tamil Unicode is preserved.
- Appropriate tests pass.
- TypeScript passes.
- Linting passes.
- Existing functionality is not broken.
- No secrets are committed.

## Current Development Priority

The current Sollu development sequence is:

```text
PostgreSQL Setup
      ↓
Database Connection
      ↓
Database Schema
      ↓
Migrations
      ↓
Seed Vocabulary
      ↓
API Database Layer
      ↓
Vocabulary Models
      ↓
Validation
      ↓
Vocabulary APIs
      ↓
Web
      ↓
Mobile
      ↓
Admin
      ↓
Testing
      ↓
Accessibility
      ↓
Performance
      ↓
Security
      ↓
Production
```
