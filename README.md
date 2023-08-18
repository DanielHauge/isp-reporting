# internet-isp-reporting

Have you ever been throttled by your ISP, perhaps paying for 1000 mbit/s, but only get 50-100 mbit/s without knowing?
If yes, you've come to the right place, as this program can collect data and generate reports of ping and bandwidth provided by ISP. Uses ookla's speedtest as foundation for evaluation.

Example of daily bandwidth (speed) **This was the day, they removed their throttle**.
![25-speed](https://github.com/DanielHauge/internet-isp-reporting/assets/9106182/6cba2c6c-93b7-4577-a50a-ece11a3d8f8d)



## Usage example

Being in the output directory for the reports, the following command can be used: **On windows pwd should be run with -W flag: ```$(pwd -W)```**

```bash
docker run -dit --name internet --restart=always -v "$(pwd)":/reports ghcr.io/danielhauge/internet-isp-reporting:main
```
