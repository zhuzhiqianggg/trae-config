# Skills Summary — Trae Config

全局 Skills 索引，按分类组织。

## Superpowers 核心工作流 (`core/`)
| Skill | Description |
|-------|-------------|
| `superpowers-brainstorming` | You MUST use this before any creative work - exploring user intent, requirements and design before implementation. |
| `superpowers-dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies |
| `superpowers-executing-plans` | Use when you have a written implementation plan to execute in a separate session with review checkpoints |
| `superpowers-finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide merge, PR, or cleanup |
| `superpowers-receiving-code-review` | Use when receiving code review feedback, before implementing suggestions |
| `superpowers-requesting-code-review` | Use when completing tasks, implementing major features, or before merging |
| `superpowers-subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session |
| `superpowers-systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior |
| `superpowers-test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `superpowers-using-git-worktrees` | Creates isolated git worktrees with smart directory selection and safety verification |
| `superpowers-using-superpowers` | Use when starting any conversation — establishes how to find and use skills |
| `superpowers-verification-before-completion` | Requires running verification commands before claiming work is complete |
| `superpowers-writing-plans` | Use when you have a spec or requirements for a multi-step task |
| `superpowers-writing-skills` | Use when creating new skills, editing existing skills |
| `core-skills-creator` | Guide the creation, review, and optimization of Trae IDE skills (SKILL.md) |
| `core-self-improving-agent` | Log learnings, errors, and corrections for continuous improvement |

## Engineering 工程实践 (`eng/`)
| Skill | Description |
|-------|-------------|
| `eng-api-and-interface-design` | Guides stable API and interface design. Contract-first, Hyrum's Law, error semantics |
| `eng-browser-testing-with-devtools` | Tests in real browsers via Chrome DevTools MCP |
| `eng-ci-cd-and-automation` | Automates CI/CD pipeline setup with quality gates |
| `eng-code-review-and-quality` | Multi-axis code review (correctness/readability/architecture/security/performance) |
| `eng-code-simplification` | Simplifies code for clarity while preserving behavior |
| `eng-context-engineering` | Optimizes agent context setup and quality |
| `eng-debugging-and-error-recovery` | Systematic root-cause debugging (reproduce-localize-reduce-fix-guard) |
| `eng-deprecation-and-migration` | Manages deprecation and migration (Strangler Fig, adapter patterns) |
| `eng-documentation-and-adrs` | Records decisions and documentation (ADR, API docs, README) |
| `eng-frontend-ui-engineering` | Builds production-quality UIs with component architecture, a11y, responsive design |
| `eng-git-workflow-and-versioning` | Git workflow practices: trunk-based, atomic commits, worktrees |
| `eng-idea-refine` | Iterative idea refinement through divergent and convergent thinking |
| `eng-incremental-implementation` | Thin vertical slices — implement, test, verify, commit |
| `eng-performance-optimization` | Measure-first performance optimization (Core Web Vitals, bundle analysis) |
| `eng-planning-and-task-breakdown` | Dependency graph > vertical slices > task templates > checkpoints |
| `eng-security-and-hardening` | OWASP Top 10 prevention, auth patterns, secrets management |
| `eng-shipping-and-launch` | Pre-launch checklists, feature flags, staged rollouts |
| `eng-source-driven-development` | Ground every implementation decision in official documentation |
| `eng-spec-driven-development` | Creates specs before coding with four-phase gate |
| `eng-test-driven-development` | Red-Green-Refactor, test pyramid, DAMP over DRY |
| `eng-using-agent-skills` | Meta-skill for discovering and invoking agent skills |

## Architecture 架构设计 (`arch/`)
| Skill | Description |
|-------|-------------|
| `arch-api-design-principles` | REST and GraphQL API design principles, scalable and maintainable |
| `arch-architecture-patterns` | Clean Architecture, Hexagonal Architecture, Domain-Driven Design |
| `arch-backend-architect` | Expert backend architect: API design, microservices, event-driven, auth, observability |
| `arch-cloud-architect` | Cloud architect: AWS/Azure/GCP multi-cloud, IaC, FinOps, disaster recovery |
| `arch-software-architecture` | Quality-focused software architecture with Clean Architecture + DDD |

## Frontend Design 前端设计 (`design/`)
| Skill | Description | Source |
|-------|-------------|--------|
| `taste-skill` | High-agency frontend design with metric-based rules, anti-slop patterns, premium aesthetic. 9 design dimensions with configurable variance/motion/density dials | leonxlnx/taste-skill (14.9k ⭐) |
| `frontend-design` | Create distinctive, production-grade frontend interfaces with intentional aesthetics and DFII scoring | agent-skills-hub (Anthropic) |
| `effective-ui-design` | WCAG 2.1 AA accessibility, OKLCH color palettes, 8pt spacing grid, fluid typography, form patterns, dark mode, SEO meta tags, Core Web Vitals | sebastian-software/effective-ui-design-skill |
| `impeccable-design` | Enhanced frontend design with 17 commands (/audit, /polish, /animate), 7 reference domains, curated anti-patterns | thatBrian/impeccable |

## SEO 搜索引擎优化 (`seo/`)
| Skill | Description |
|-------|-------------|
| `seo-fundamentals` | Core SEO principles: E-E-A-T, Core Web Vitals, technical foundations, content quality |
| `seo-audit` | Comprehensive SEO audit: crawlability, indexation, on-page, content quality, technical issues |
| `seo-content-writer` | SEO-optimized content writing with keyword strategy, E-E-A-T signals, content frameworks |
| `programmatic-seo` | Create SEO-driven pages at scale using templates and data (12 playbooks) |
| `ai-seo` | Optimize content for AI search engines: ChatGPT, Perplexity, Google AI Overviews, Gemini, Claude |

## Operations 运维管理 (`ops/`)
| Skill | Description |
|-------|-------------|
| `ops-linux-troubleshooter` | Linux 系统问题排查：CPU/内存/磁盘/网络问题诊断与解决 |
| `ops-log-analysis` | Linux/Docker/Kubernetes/Nginx 日志收集和分析 |
| `database-admin` | Database administration: setup, backup, monitoring, user management, migration |
| `database-optimizer` | Database performance optimization: indexing, query tuning, schema design, connection pooling |
| `docker-essentials` | Essential Docker commands and workflows for container management, image operations, debugging |
| `kubernetes-devops` | Production-ready K8s manifest generation with security contexts, health checks, Helm charts |
| `monitoring` | Complete observability: Prometheus/Grafana/Loki/Sentry, alerting, SLOs, cost comparison |
| `devops-automation-pack` | DevOps automation: Docker/K8s/CI-CD/monitoring/backup scripts and templates |
| `postgres-best-practices` | PostgreSQL best practices: schema design, indexing, migration, configuration, backup |
| `incident-responder` | Incident response: severity levels, runbooks, communication, post-mortem patterns |
| `network-engineer` | Network engineering: DNS, TCP/IP, load balancing, firewall, VPN, CDN configuration |
| `gitops-workflow` | GitOps workflow with ArgoCD/Flux: declarative infrastructure, sync strategies |
| `bash-pro` | Advanced Bash scripting: error handling, argument parsing, safety guards, performance patterns |
| `github-actions-templates` | GitHub Actions workflow templates for CI/CD, testing, deployment |

## DevOps 部署运维 (`devops/`)
| Skill | Description |
|-------|-------------|
| `devops-terraform` | Terraform/OpenTofu IaC automation, state management, multi-cloud deployment |
| `devops-terraform-engineer` | Senior Terraform engineer: modules, state, multi-cloud, testing, CI/CD |
| `devops-troubleshooter` | DevOps troubleshooting: CI/CD failures, infrastructure issues, deployment problems |
| `devops-vercel-deployment` | Vercel + Next.js deployment: env vars, Edge vs Serverless, preview deploys |

## Security 安全 (`sec/`)
| Skill | Description |
|-------|-------------|
| `sec-api-security` | Secure API design: authentication, authorization, input validation, rate limiting, OWASP API Top 10 |
| `sec-security-review` | Security review checklist: secrets, input validation, SQL injection, XSS/CSRF |

## Code Quality 代码质量 (`quality/`)
| Skill | Description |
|-------|-------------|
| `quality-architect-review` | Architecture review: system design, scalability, maintainability |
| `quality-clean-code` | Clean code standards: SRP/DRY/KISS/YAGNI, naming, function rules |

## Testing 测试 (`test/`)
| Skill | Description |
|-------|-------------|
| `test-test-automator` | AI-powered test automation with Playwright/Selenium/Appium, CI/CD integration |
| `test-testing-patterns` | Jest testing patterns, factory functions, mocking strategies, TDD workflow |

## Documentation 文档编写 (`doc/`)
| Skill | Description |
|-------|-------------|
| `doc-api-documentation` | Comprehensive API documentation with endpoints, parameters, examples |
| `doc-architecture-decision-records` | ADR writing and maintenance with 5 template types |

## Git 版本控制 (`git/`)
| Skill | Description |
|-------|-------------|
| `git-using-git-worktrees` | Git worktree isolation for parallel development branches |

## React & Next.js (`react/`)
| Skill | Description |
|-------|-------------|
| `react-patterns` | Modern React patterns: hooks, composition, performance, TypeScript, React 19 |
| `react-state-management` | State management with Redux Toolkit, Zustand, Jotai, React Query |
| `nextjs-app-router-patterns` | Next.js 14+ App Router: Server Components, streaming, parallel routes, data fetching |

## Programming Patterns (`patterns/`)
| Skill | Description |
|-------|-------------|
| `error-handling-patterns` | Cross-language error handling: exceptions, Result types, circuit breaker, graceful degradation |
| `web-performance-optimization` | Web performance: Core Web Vitals, bundle optimization, caching, image optimization |
| `prompt-engineering` | Prompt engineering: few-shot, chain-of-thought, system prompts, optimization techniques |

## WSL 管理 (`wsl/`)
| Skill | Description |
|-------|-------------|
| `wsl-manager` | WSL2 综合管理：网络/DNS 问题排查、发行版配置、性能优化 |

**Total: 85 skills** (16 core + 69 others)
