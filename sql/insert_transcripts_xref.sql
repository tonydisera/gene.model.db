CREATE TABLE GRCh37_xref_gencode_to_refseq (gene_name text, refseq_id text, gencode_id text, species text, build text);
CREATE INDEX idx_grch37_xref1 on GRCh37_xref_gencode_to_refseq(refseq_id);
CREATE INDEX idx_grch37_xref2 on GRCh37_xref_gencode_to_refseq(gencode_id);
CREATE INDEX idx_grch37_xref3 on GRCh37_xref_gencode_to_refseq(gene_name);

CREATE TABLE GRCh38_xref_gencode_to_refseq (gene_name text, refseq_id text, gencode_id text, species text, build text);
CREATE INDEX idx_grch38_xref1 on GRCh38_xref_gencode_to_refseq(refseq_id);
CREATE INDEX idx_grch38_xref2 on GRCh38_xref_gencode_to_refseq(gencode_id);
CREATE INDEX idx_grch38_xref3 on GRCh38_xref_gencode_to_refseq(gene_name);

CREATE INDEX idx_transcripts_gene_name on transcripts(gene_name);
CREATE INDEX idx_transcripts_build on transcripts(build);

.separator ","
.import /users/tonyd/work/geneModelGffImporter/data/GRCh37_xref_gencode_to_refseq.csv GRCh37_xref_gencode_to_refseq
.import /users/tonyd/work/geneModelGffImporter/data/GRCh38_xref_gencode_to_refseq.csv GRCh38_xref_gencode_to_refseq


insert into xref_transcript(gene_name, refseq_id, gencode_id, species, build)
select gene_name, refseq_id, gencode_id, species, build
 from GRCh38_xref_gencode_to_refseq
 where refseq_id != '';


insert into xref_transcript(gene_name, refseq_id, gencode_id, species, build)
select x.gene_name, x.refseq_id, t.transcript_id, x.species, x.build 
from GRCh37_xref_gencode_to_refseq as x  join transcripts as t 
    on t.build = x.build 
    and SUBSTR(t.transcript_id, 1,LENGTH(t.transcript_id)-2) = x.gencode_id 
    and t.gene_name = x.gene_name 
    and t.source = 'gencode'
where x.refseq_id != '';


