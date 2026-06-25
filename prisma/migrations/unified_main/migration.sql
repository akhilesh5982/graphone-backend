-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "papers" (
    "id" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "short_title" TEXT,
    "abstract" TEXT,
    "tl_dr" TEXT,
    "publication_date" TIMESTAMP(3),
    "submission_date" TIMESTAMP(3),
    "arxiv_id" TEXT,
    "doi" TEXT,
    "paper_url" TEXT,
    "pdf_url" TEXT,
    "source_url" TEXT,
    "project_url" TEXT,
    "citation_count" INTEGER NOT NULL DEFAULT 0,
    "reference_count" INTEGER NOT NULL DEFAULT 0,
    "page_count" INTEGER,
    "paper_type" TEXT,
    "status" TEXT,
    "language" TEXT,
    "license" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3),

    CONSTRAINT "papers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "entity_relationships" (
    "id" TEXT NOT NULL,
    "source_entity_type" TEXT NOT NULL,
    "source_entity_id" TEXT NOT NULL,
    "target_entity_type" TEXT NOT NULL,
    "target_entity_id" TEXT NOT NULL,
    "relationship_type" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL DEFAULT 1.0,
    "metadata_json" JSONB,

    CONSTRAINT "entity_relationships_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "startups" (
    "id" TEXT NOT NULL,
    "canonical_name" TEXT NOT NULL,
    "source_name" TEXT,
    "source_url" TEXT,
    "employee_count" INTEGER,
    "collected_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "startups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tasks" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "color" TEXT,

    CONSTRAINT "tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "paper_tasks" (
    "paper_id" TEXT NOT NULL,
    "task_id" TEXT NOT NULL,

    CONSTRAINT "paper_tasks_pkey" PRIMARY KEY ("paper_id","task_id")
);

-- CreateTable
CREATE TABLE "methods" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "methods_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "paper_methods" (
    "paper_id" TEXT NOT NULL,
    "method_id" TEXT NOT NULL,

    CONSTRAINT "paper_methods_pkey" PRIMARY KEY ("paper_id","method_id")
);

-- CreateTable
CREATE TABLE "benchmarks" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,

    CONSTRAINT "benchmarks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sota_claims" (
    "id" TEXT NOT NULL,
    "paper_id" TEXT NOT NULL,
    "benchmark_id" TEXT NOT NULL,

    CONSTRAINT "sota_claims_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rankings" (
    "id" TEXT NOT NULL,
    "paper_id" TEXT NOT NULL,
    "benchmark_id" TEXT NOT NULL,
    "rank" INTEGER NOT NULL,
    "previous_rank" INTEGER,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rankings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "papers_slug_key" ON "papers"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "papers_arxiv_id_key" ON "papers"("arxiv_id");

-- CreateIndex
CREATE INDEX "entity_relationships_source_entity_type_source_entity_id_idx" ON "entity_relationships"("source_entity_type", "source_entity_id");

-- CreateIndex
CREATE INDEX "entity_relationships_target_entity_type_target_entity_id_idx" ON "entity_relationships"("target_entity_type", "target_entity_id");

-- CreateIndex
CREATE UNIQUE INDEX "entity_relationships_source_entity_id_target_entity_id_rela_key" ON "entity_relationships"("source_entity_id", "target_entity_id", "relationship_type");

-- CreateIndex
CREATE UNIQUE INDEX "startups_canonical_name_key" ON "startups"("canonical_name");

-- CreateIndex
CREATE UNIQUE INDEX "tasks_name_key" ON "tasks"("name");

-- CreateIndex
CREATE UNIQUE INDEX "tasks_slug_key" ON "tasks"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "methods_name_key" ON "methods"("name");

-- CreateIndex
CREATE UNIQUE INDEX "methods_slug_key" ON "methods"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "benchmarks_name_key" ON "benchmarks"("name");

-- CreateIndex
CREATE UNIQUE INDEX "benchmarks_slug_key" ON "benchmarks"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "sota_claims_paper_id_benchmark_id_key" ON "sota_claims"("paper_id", "benchmark_id");

-- CreateIndex
CREATE INDEX "rankings_benchmark_id_rank_idx" ON "rankings"("benchmark_id", "rank");

-- CreateIndex
CREATE UNIQUE INDEX "rankings_paper_id_benchmark_id_key" ON "rankings"("paper_id", "benchmark_id");

-- AddForeignKey
ALTER TABLE "paper_tasks" ADD CONSTRAINT "paper_tasks_paper_id_fkey" FOREIGN KEY ("paper_id") REFERENCES "papers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "paper_tasks" ADD CONSTRAINT "paper_tasks_task_id_fkey" FOREIGN KEY ("task_id") REFERENCES "tasks"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "paper_methods" ADD CONSTRAINT "paper_methods_paper_id_fkey" FOREIGN KEY ("paper_id") REFERENCES "papers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "paper_methods" ADD CONSTRAINT "paper_methods_method_id_fkey" FOREIGN KEY ("method_id") REFERENCES "methods"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sota_claims" ADD CONSTRAINT "sota_claims_paper_id_fkey" FOREIGN KEY ("paper_id") REFERENCES "papers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "sota_claims" ADD CONSTRAINT "sota_claims_benchmark_id_fkey" FOREIGN KEY ("benchmark_id") REFERENCES "benchmarks"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rankings" ADD CONSTRAINT "rankings_paper_id_fkey" FOREIGN KEY ("paper_id") REFERENCES "papers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rankings" ADD CONSTRAINT "rankings_benchmark_id_fkey" FOREIGN KEY ("benchmark_id") REFERENCES "benchmarks"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
