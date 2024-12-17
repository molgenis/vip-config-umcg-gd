# VIP configuration files for UMCG diagnostics

## Catalog converter HOWTO
- oneDrive: Download catalog excel
- save sheet as TSV
- run converter.sh
```bash catalogConverter.sh -i StrCatalog_v{VERSION}.txt -p v{VERSION} -f```
- create PR with json and bed
- oneDrive: copy excel, increase the versionnumber
- remove -SNAPSHOT from the previous snapshot version
- oneDrive: move the previous "production" excel to "archive"
- oneDrive: update versiebeheer.txt
 