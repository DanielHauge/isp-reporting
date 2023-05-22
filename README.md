# internet-isp-reporting

## Usage example

Being in the output directory for the reports, the following command can be used: **On windows pwd should be run with -W flag: ```$(pwd -W)```**

```bash
docker run -dit --name internet --restart=always -v "$(pwd)":/reports ghcr.io/danielhauge/internet-isp-reporting:main
```
