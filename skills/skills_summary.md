# Skills Summary — Trae Config
全局 Skills 索引，按分类组织。

## Superpowers 核心工作流
| Skill | Description |
|-------|-------------|
| `superpowers-brainstorming` | "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation." |
| `superpowers-dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies |
| `superpowers-executing-plans` | Use when you have a written implementation plan to execute in a separate session with review checkpoints |
| `superpowers-finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup |
| `superpowers-receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation |
| `superpowers-requesting-code-review` | Use when completing tasks, implementing major features, or before merging to verify work meets requirements |
| `superpowers-subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session |
| `superpowers-systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes |
| `superpowers-test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `superpowers-using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification |
| `superpowers-using-superpowers` | Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions |
| `superpowers-verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always |
| `superpowers-writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code |
| `superpowers-writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before deployment |

## Engineering 工程实践 (addyosmani)
| Skill | Description |
|-------|-------------|
| `eng-api-and-interface-design` | Guides stable API and interface design. Use when designing APIs, module boundaries, or any public interface. Use when creating REST or GraphQL endpoints, defining type contracts between modules, or establishing boundaries between frontend and backend. |
| `eng-browser-testing-with-devtools` | Tests in real browsers. Use when building or debugging anything that runs in a browser. Use when you need to inspect the DOM, capture console errors, analyze network requests, profile performance, or verify visual output with real runtime data via Chrome DevTools MCP. |
| `eng-ci-cd-and-automation` | Automates CI/CD pipeline setup. Use when setting up or modifying build and deployment pipelines. Use when you need to automate quality gates, configure test runners in CI, or establish deployment strategies. |
| `eng-code-review-and-quality` | Conducts multi-axis code review. Use before merging any change. Use when reviewing code written by yourself, another agent, or a human. Use when you need to assess code quality across multiple dimensions before it enters the main branch. |
| `eng-code-simplification` | Simplifies code for clarity. Use when refactoring code for clarity without changing behavior. Use when code works but is harder to read, maintain, or extend than it should be. Use when reviewing code that has accumulated unnecessary complexity. |
| `eng-context-engineering` | Optimizes agent context setup. Use when starting a new session, when agent output quality degrades, when switching between tasks, or when you need to configure rules files and context for a project. |
| `eng-debugging-and-error-recovery` | Guides systematic root-cause debugging. Use when tests fail, builds break, behavior doesn't match expectations, or you encounter any unexpected error. Use when you need a systematic approach to finding and fixing the root cause rather than guessing. |
| `eng-deprecation-and-migration` | Manages deprecation and migration. Use when removing old systems, APIs, or features. Use when migrating users from one implementation to another. Use when deciding whether to maintain or sunset existing code. |
| `eng-documentation-and-adrs` | Records decisions and documentation. Use when making architectural decisions, changing public APIs, shipping features, or when you need to record context that future engineers and agents will need to understand the codebase. |
| `eng-frontend-ui-engineering` | Builds production-quality UIs. Use when building or modifying user-facing interfaces. Use when creating components, implementing layouts, managing state, or when the output needs to look and feel production-quality rather than AI-generated. |
| `eng-git-workflow-and-versioning` | Structures git workflow practices. Use when making any code change. Use when committing, branching, resolving conflicts, or when you need to organize work across multiple parallel streams. |
| `eng-idea-refine` | Refines ideas iteratively. Refine ideas through structured divergent and convergent thinking. Use "idea-refine" or "ideate" to trigger. |
| `eng-incremental-implementation` | Delivers changes incrementally. Use when implementing any feature or change that touches more than one file. Use when you're about to write a large amount of code at once, or when a task feels too big to land in one step. |
| `eng-performance-optimization` | Optimizes application performance. Use when performance requirements exist, when you suspect performance regressions, or when Core Web Vitals or load times need improvement. Use when profiling reveals bottlenecks that need fixing. |
| `eng-planning-and-task-breakdown` | Breaks work into ordered tasks. Use when you have a spec or clear requirements and need to break work into implementable tasks. Use when a task feels too large to start, when you need to estimate scope, or when parallel work is possible. |
| `eng-security-and-hardening` | Hardens code against vulnerabilities. Use when handling user input, authentication, data storage, or external integrations. Use when building any feature that accepts untrusted data, manages user sessions, or interacts with third-party services. |
| `eng-shipping-and-launch` | Prepares production launches. Use when preparing to deploy to production. Use when you need a pre-launch checklist, when setting up monitoring, when planning a staged rollout, or when you need a rollback strategy. |
| `eng-source-driven-development` | Grounds every implementation decision in official documentation. Use when you want authoritative, source-cited code free from outdated patterns. Use when building with any framework or library where correctness matters. |
| `eng-spec-driven-development` | Creates specs before coding. Use when starting a new project, feature, or significant change and no specification exists yet. Use when requirements are unclear, ambiguous, or only exist as a vague idea. |
| `eng-test-driven-development` | Drives development with tests. Use when implementing any logic, fixing any bug, or changing any behavior. Use when you need to prove that code works, when a bug report arrives, or when you're about to modify existing functionality. |
| `eng-using-agent-skills` | Discovers and invokes agent skills. Use when starting a session or when you need to discover which skill applies to the current task. This is the meta-skill that governs how all other skills are discovered and invoked. |

## Architecture 架构设计
| Skill | Description |
|-------|-------------|
| `arch-api-design-principles` | Master REST and GraphQL API design principles to build intuitive, scalable, and maintainable APIs that delight developers. Use when designing new APIs, reviewing API specifications, or establishing API design standards. |
| `arch-architecture-patterns` | Implement proven backend architecture patterns including Clean Architecture, Hexagonal Architecture, and Domain-Driven Design. Use when architecting complex backend systems or refactoring existing applications for better maintainability. |
| `arch-backend-architect` | Expert backend architect specializing in scalable API design, |
| `arch-cloud-architect` | Expert cloud architect specializing in AWS/Azure/GCP multi-cloud |
| `arch-software-architecture` | Guide for quality focused software architecture. This skill should be used when users want to write code, design architecture, analyze code, in any case that relates to software development. |

## Code Quality 代码质量
| Skill | Description |
|-------|-------------|
| `quality-architect-review` | Master software architect specializing in modern architecture |
| `quality-clean-code` | Pragmatic coding standards - concise, direct, no over-engineering, no unnecessary comments |
| `quality-code-refactoring` | "You are a code refactoring expert specializing in clean code principles, SOLID design patterns, and modern software engineering best practices. Analyze and refactor the provided code to improve its quality, maintainability, and performance." |

## Testing 测试
| Skill | Description |
|-------|-------------|
| `test-api-testing` | "You are an API mocking expert specializing in realistic mock services for development, testing, and demos. Design mocks that simulate real API behavior and enable parallel development." |
| `test-test-automator` | Master AI-powered test automation with modern frameworks, |
| `test-testing-patterns` | Jest testing patterns, factory functions, mocking strategies, and TDD workflow. Use when writing unit tests, creating test factories, or following TDD red-green-refactor cycle. |

## DevOps 部署运维
| Skill | Description |
|-------|-------------|
| `devops-cicd-automation` | "You are a workflow automation expert specializing in creating efficient CI/CD pipelines, GitHub Actions workflows, and automated development processes. Design automation that reduces manual work, improves consistency, and accelerates delivery while maintaining quality and security." |
| `devops-terraform` | Expert Terraform/OpenTofu specialist mastering advanced IaC |
| `devops-vercel-deployment` | "Expert knowledge for deploying to Vercel with Next.js Use when: vercel, deploy, deployment, hosting, production." |

## Security 安全
| Skill | Description |
|-------|-------------|
| `sec-api-security` | "Implement secure API design patterns including authentication, authorization, input validation, rate limiting, and protection against common API vulnerabilities" |
| `sec-security-review` | Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides comprehensive security checklist and patterns. |

## Git 版本控制
| Skill | Description |
|-------|-------------|
| `git-using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification |

## Documentation 文档编写
| Skill | Description |
|-------|-------------|
| `doc-api-documentation` | "Generate comprehensive, developer-friendly API documentation from code, including endpoints, parameters, examples, and best practices" |
| `doc-architecture-decision-records` | Write and maintain Architecture Decision Records (ADRs) following best practices for technical decision documentation. Use when documenting significant technical decisions, reviewing past architectural choices, or establishing decision processes. |
| `doc-code-documentation` | "You are a code education expert specializing in explaining complex code through clear narratives, visual diagrams, and step-by-step breakdowns. Transform difficult concepts into understandable explanations." |
| `doc-doc-generate` | "You are a documentation expert specializing in creating comprehensive, maintainable documentation from code. Generate API docs, architecture diagrams, user guides, and technical references using AI-powered analysis and industry best practices." |

**Total: 56 skills**
