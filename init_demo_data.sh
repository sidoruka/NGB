until $(curl --output /dev/null --silent --head --fail http://localhost:8080/catgenome); do
    printf '.'
    sleep 5
done

cd /opt
mkdir data
cd data/

wget http://ngb.opensource.epam.com/distr/data/genome/grch38/Homo_sapiens.GRCh38.gtf.gz
wget http://ngb.opensource.epam.com/distr/data/genome/grch38/Homo_sapiens.GRCh38.fa.gz
wget http://ngb.opensource.epam.com/distr/data/genome/dm6/dmel-all-r6.06.sorted.gtf.gz
wget http://ngb.opensource.epam.com/distr/data/genome/dm6/dmel-all-chromosome-r6.06.fasta.gz
wget http://ngb.opensource.epam.com/distr/data/demo/ngb_demo_data.tar.gz

gzip -d Homo_sapiens.GRCh38.fa.gz
gzip -d dmel-all-chromosome-r6.06.fasta.gz

tar -zxvf ngb_demo_data.tar.gz
rm ngb_demo_data.tar.gz

ngb reg_ref /opt/data/Homo_sapiens.GRCh38.fa --name GRCh38
ngb reg_file GRCh38 /opt/data/Homo_sapiens.GRCh38.gtf.gz --name GRCh38_Genes
ngb ag GRCh38 GRCh38_Genes

ngb reg_ref /opt/data/dmel-all-chromosome-r6.06.fasta --name DM6
ngb reg_file DM6 /opt/data/dmel-all-r6.06.sorted.gtf.gz --name DM6_Genes
ngb ag DM6 DM6_Genes

ngb reg_file GRCh38 /opt/data/ngb_demo_data/sample_1-lumpy.vcf
ngb reg_file GRCh38 /opt/data/ngb_demo_data/sv_sample_1.bw
ngb reg_file GRCh38 /opt/data/ngb_demo_data/sv_sample_1.bam?/opt/data/ngb_demo_data/sv_sample_1.bam.bai
ngb rd GRCh38 SV_Sample1
ngb add SV_Sample1 sample_1-lumpy.vcf
ngb add SV_Sample1 sv_sample_1.bw
ngb add SV_Sample1 sv_sample_1.bam

ngb reg_file GRCh38 /opt/data/ngb_demo_data/sample_2-lumpy.vcf
ngb reg_file GRCh38 /opt/data/ngb_demo_data/sv_sample_2.bw
ngb reg_file GRCh38 /opt/data/ngb_demo_data/sv_sample_2.bam?/opt/data/ngb_demo_data/sv_sample_2.bam.bai
ngb rd GRCh38 SV_Sample2
ngb add SV_Sample2 sample_2-lumpy.vcf
ngb add SV_Sample2 sv_sample_2.bw
ngb add SV_Sample2 sv_sample_2.bam

ngb reg_file GRCh38 /opt/data/ngb_demo_data/PIK3CA-E545K.vcf
ngb reg_file GRCh38 /opt/data/ngb_demo_data/PIK3CA-E545K.bam?/opt/data/ngb_demo_data/PIK3CA-E545K.bam.bai
ngb reg_file GRCh38 /opt/data/ngb_demo_data/PIK3CA-E545K.cram?/opt/data/ngb_demo_data/PIK3CA-E545K.cram.crai
ngb rd GRCh38 PIK3CA-E545K-Sample
ngb add PIK3CA-E545K-Sample PIK3CA-E545K.vcf
ngb add PIK3CA-E545K-Sample PIK3CA-E545K.bam
ngb add PIK3CA-E545K-Sample PIK3CA-E545K.cram

ngb reg_file GRCh38 /opt/data/ngb_demo_data/brain_th.bam?/opt/data/ngb_demo_data/brain_th.bam.bai
ngb rd GRCh38 RNASeq-chr22-SpliceJunctions
ngb add RNASeq-chr22-SpliceJunctions brain_th.bam

ngb reg_file GRCh38 /opt/data/ngb_demo_data/FGFR3-TACC-Fusion.vcf
ngb reg_file GRCh38 /opt/data/ngb_demo_data/FGFR3-TACC-Fusion.bam?/opt/data/ngb_demo_data/FGFR3-TACC-Fusion.bam.bai
ngb rd GRCh38 FGFR3-TACC-Fusion-Sample
ngb add FGFR3-TACC-Fusion-Sample FGFR3-TACC-Fusion.vcf
ngb add FGFR3-TACC-Fusion-Sample FGFR3-TACC-Fusion.bam

ngb reg_file DM6 /opt/data/ngb_demo_data/agnX1.09-28.trim.dm606.realign.vcf
ngb reg_file DM6 /opt/data/ngb_demo_data/agnX1.09-28.trim.dm606.realign.bam?/opt/data/ngb_demo_data/agnX1.09-28.trim.dm606.realign.bai
ngb reg_file DM6 /opt/data/ngb_demo_data/CantonS.09-28.trim.dm606.realign.vcf
ngb reg_file DM6 /opt/data/ngb_demo_data/CantonS.09-28.trim.dm606.realign.bam?/opt/data/ngb_demo_data/CantonS.09-28.trim.dm606.realign.bai
ngb reg_file DM6 /opt/data/ngb_demo_data/agnts3.09-28.trim.dm606.realign.vcf
ngb reg_file DM6 /opt/data/ngb_demo_data/agnts3.09-28.trim.dm606.realign.bam?/opt/data/ngb_demo_data/agnts3.09-28.trim.dm606.realign.bai
ngb rd DM6 Fruitfly
ngb add Fruitfly agnX1.09-28.trim.dm606.realign.vcf
ngb add Fruitfly agnX1.09-28.trim.dm606.realign.bam
ngb add Fruitfly CantonS.09-28.trim.dm606.realign.vcf
ngb add Fruitfly CantonS.09-28.trim.dm606.realign.bam
ngb add Fruitfly agnts3.09-28.trim.dm606.realign.vcf
ngb add Fruitfly agnts3.09-28.trim.dm606.realign.bam
