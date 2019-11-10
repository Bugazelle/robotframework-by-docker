# RF Samples 

> Note: Assume you put the **samples** folder into the current folder

- **Run Test (use default browser - Chrome)**

    ```
    docker run \
        -e VNC_RESOLUTION=1400x900 \
        -p 6901:6901 \
        -p 5901:5901 \
        -v $(pwd):/tmp \
        --privileged \
        -v /dev/shm:/dev/shm \
        --shm-size 2048m \
        bugazelle/robotframework:latest \
        /bin/bash -c "cd Sample; \
        robot --outputdir Reports/RunTest sample_1.robot"
    ```
    
- **Run Parallel Test (use browser - Firefox)**

    ```
    docker run \
        -e VNC_RESOLUTION=1400x900 \
        -p 6901:6901 \
        -p 5901:5901 \
        -v $(pwd):/tmp \
        --privileged \
        -v /dev/shm:/dev/shm \
        --shm-size 2048m \
        bugazelle/robotframework:latest \
        /bin/bash -c "cd Sample; \
        pabot --processes 2 --outputdir Reports/RunParallelTest --variable BROWSER:Firefox *.robot"
    ```

- **Run Cross Browsers Test**

    ```
    docker run \
        -e VNC_RESOLUTION=1400x900 \
        -p 6901:6901 \
        -p 5901:5901 \
        -v $(pwd):/tmp \
        --privileged \
        -v /dev/shm:/dev/shm \
        --shm-size 2048m \
        bugazelle/robotframework:latest \
        /bin/bash -c "cd Sample; \
        pabot --argumentfile1 firefox.args --argumentfile2 chrome.args --processes 4 --outputdir Reports/RunCrossBrowserTest *.robot"
    ```
