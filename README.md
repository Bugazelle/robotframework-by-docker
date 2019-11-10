# Robot Framework by Docker 

Pull the docker image from: 

```
docker pull bugazelle/robotframework
```

![](noVNC_Sample.gif)

## Content
- [Supports](#supports)
- [Highlight: NoVNC, Jenkins, CNTLM](#highlight)
- [How To Run](#how-to-run)
- [RF Samples](#rf-samples)
- [System Info](#system-info)
- [Useful Links](#useful-links)

## Supports
Support the Robot Framework for both Python2.7 & Python 3.6.

1. [robotframework: 3.1.2](https://pypi.org/project/robotframework/)
2. [robotframework-seleniumlibrary: 4.1.0](https://pypi.org/project/robotframework-seleniumlibrary/)
3. [robotframework-selenium2library: 1.8.0 (Only for Python2.7. It's legacy lib and not suggested to use)](https://pypi.org/project/robotframework-selenium2library/1.8.0/)
4. [robotframework-pabot: 0.91](https://pypi.org/project/robotframework-pabot/)
5. Robot Command for Python2.7:
   - `robot --version`
   - `robot2 --version`
   - `rebot --version`
   - `rebot2 --version`
   - `pabot --version`
   - `pabot2 --version`
6. Robot Command for Python3:
   - `robot3 --version`
   - `rebot3 --version`
   - `pabot3 --version`

> Chrome/ChromeDriver: 77.0.3865.120/77.0.3865.40, Firefox/Geckodriver: 69.0.3/0.26.0, Selenium Sever: 3.9.1
> - If you would like to require a certain version of chrome/chromedirver, firefox/geckodriver and selenium server, please raise a issue. I will build the image for you.

## Highlight
1. Support noVNC
   
   Allow you to debug/watch the test running in a more "visual" way at: [http://127.0.0.1:6901/?password=vncpassword](http://127.0.0.1:6901/?password=vncpassword)
   
   For more info about noVNC: [docker-headless-vnc-container](https://github.com/Bugazelle/docker-headless-vnc-container)
     
   **-e VNC_RESOLUTION=1400x900**: set screen resolution to 1400x900
   
   **-p 6901:6901**: map vnc client port
   
   **-p 5901:5901**: map vnc server port
   
   **-v $(pwd):/tmp**: map files from current folder to container /tmp
   
   ```
   docker run \
       -e VNC_RESOLUTION=1400x900 \
       -p 6901:6901 \
       -p 5901:5901 \
       -v $(pwd):/tmp \
       bugazelle/robotframework
   ```
   
2. Support Jenkins

   Run as a jenkins slave/agent. Available environments parameters:
   
   **JENKINS_MASTER_URL**: Master url of the jenkins, default: http://127.0.0.1:8080
   
   **JENKINS_SLAVE_KEY**: Something like: bb23de4d485447d3f8b73aefa268e687d5660dad553eb4534ff2ae369d7849c6
   
   **JENKINS_SLAVE_NAME**: Jenkins slave name
   
   **JENKINS_AGENT_WORKDIR**: Jenkins agent home, default: /home/jenkins
   
   3 Ways to connect jenkins master, for example:
   
   - Suggested: `jenkins-run.sh`
   
   - `jenkins-agent -url ${JENKINS_MASTER_URL} ${JENKINS_SLAVE_KEY} ${JENKINS_SLAVE_NAME}`
   
   - `java -jar /usr/share/jenkins/agent.jar -jnlpUrl ${JENKINS_MASTER_URL}/computer/slave1/slave-agent.jnlp -secret ${JENKINS_SLAVE_KEY}`
   
   ``` 
   docker run \
       -e VNC_RESOLUTION=1400x900 \
       -p 6901:6901 \
       -p 5901:5901 \
       -v $(pwd):/tmp \
       -e JENKINS_MASTER_URL=http://172.17.0.1:8080 \
       -e JENKINS_SLAVE_KEY=1f27b72ec9cf59711788e8de7d1219766381c1ea0406b5f64de3bb6dcd6df913 \
       -e JENKINS_SLAVE_NAME=slave1 \
       bugazelle/robotframework jenkins-run.sh
   ```
   
   If you would like to setup a jenkins ci/cd environment by docker, more info here: [jenkins/README.md](jenkins/README.md)
   
3. Support CNTLM

   If behind the NTLM proxy, use the CNTLM. Get more info here: [https://linux.die.net/man/1/cntlm](https://linux.die.net/man/1/cntlm)
   
   Available environments parameters:
   
   **CNTLM_PROXY_DOMAIN**: default: global
   
   **CNTLM_PROXY_AUTH**: default: NTLMv2
   
   **CNTLM_PROXY_USER**: no default, please see the configuration in cntlm.conf.tmpl
   
   **CNTLM_PROXY_KEY**: no default, please see the configuration in cntlm.conf.tmpl. Use `cntlm -u YourUserName -H` to get the key.
   
   **CNTLM_PROXY_SERVER**: no default, please see the configuration in cntlm.conf.tmpl. And you could add more proxy server by: CNTLM_PROXY_SERVER_1, CNTLM_PROXY_SERVER_2, CNTLM_PROXY_SERVER_3, CNTLM_PROXY_SERVER_4, CNTLM_PROXY_SERVER_5
   
   **CNTLM_NO_PROXY**: please see the configuration in cntlm.conf.tmpl. default: localhost, 127.0.0.*, 10.*, 192.168.*, 172.17.*
   
   **How to run**: `cntlm-run.sh`, then the proxy should be ready at local: [http://127.0.0.1:3128](http://127.0.0.1:3128)
 
   ```
   docker run \
       -e VNC_RESOLUTION=1400x900 \
       -p 6901:6901 \
       -p 5901:5901 \
       -v $(pwd):/tmp \
       -e CNTLM_PROXY_DOMAIN=global \
       -e CNTLM_PROXY_AUTH=NTLMv2 \
       -e CNTLM_PROXY_USER=YourUserName \
       -e CNTLM_PROXY_KEY=YourKey \
       -e CNTLM_PROXY_SERVER=TheProxyServer, like my.proxy:3128 \
       bugazelle/robotframework /bin/bash -c "cntlm-run.sh; \
          export http_proxy=http://127.0.0.1:3128; \
          export https_proxy=http://127.0.0.1:3128; \
          wget --no-check-certificate http://apache.org; "
   ```
   
## How To Run

1. Debug Purpose & Run Step by Step
   
   1) Start Container, and map the current path to container /tmp
   
      > Note: Sometimes the chromedriver, geckdriver running failed at container, add `--privileged -v /dev/shm:/dev/shm --shm-size 2048m` to solve the issue
   
       ``` 
       docker run \
           -e VNC_RESOLUTION=1400x900 \
           -p 6901:6901 \
           -p 5901:5901 \
           -v $(pwd):/tmp \
           --privileged \
           -v /dev/shm:/dev/shm \
           --shm-size 2048m \
           bugazelle/robotframework
       ```
   
   2) Access the [http://localhost:6901/?password=vncpassword/](http://localhost:6901/?password=vncpassword/) to the vnc env.
   
   3) launch "terminal", run the test as bellow.
   
       ``` 
       cd /tmp;
       ls -l;
       cd samples/;
       # Python 2.7
       robot --outputdir Reports/RunTest sample_1.robot
       # Python 3
       robot3 --outputdir Reports/RunTest sample_1.robot
       ```

2. Run Directly

   ``` 
   docker run \
       -e VNC_RESOLUTION=1400x900 \
       -p 6901:6901 \
       -p 5901:5901 \
       -v $(pwd):/tmp \
       --privileged \
       -v /dev/shm:/dev/shm \
       --shm-size 2048m \
       bugazelle/robotframework \
           /bin/bash -c "cd /tmp/samples/; \
           robot --outputdir Reports/RunTest sample_1.robot;"
    ```

## RF Samples

[RF Samples: Run Test / Run Parallel Test / Run Cross Browsers Test](samples)

## System Info

1. OS: Ubuntu 18.04

2. Chrome/ChromeDriver: 77.0.3865.120/77.0.3865.40

3. Firefox/Geckodriver: 69.0.3/0.26.0

4. PhantomJS: 2.1.1

5. Java: 1.8.0.222

6. Git: 2.17.x

7. Default User: robot-framework (with sudo access)

## Useful Links
1. [Robot Build In Library](http://robotframework.org/robotframework/#standard-libraries)

2. [Selenium Library](http://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)

3. [All Possible Library](http://robotframework.org/robotframework/#standard-libraries)

4. [GeckoDriver](https://github.com/mozilla/geckodriver/releases)

5. [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/)

6. [PhantomJS](http://phantomjs.org/download.html)

7. [Previous Chrome RPM Package](http://orion.lcg.ufrj.br/RPMS/myrpms/google/)

8. Previous Chromium: [https://github.com/Bugazelle/chromium-all-old-stable-versions](https://github.com/Bugazelle/chromium-all-old-stable-versions)

9. [Previous Firefox](https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/)
