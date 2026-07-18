export interface Post {
  id: string
  title: string
  slug: string
  content: string
  excerpt: string
  publishedAt: string
  updatedAt?: string
  author: Author
  tags: string[]
  coverImage?: string
}

export interface Author {
  id: string
  name: string
  bio: string
  avatar?: string
  socials?: {
    twitter?: string
    github?: string
    linkedin?: string
  }
}
