# RausiPools Scripts (ITN)
![Distribution](https://github.com/rausi/RausiPool/blob/master/RausiPoolNew.png)

**RausiPools information**<br>
Please see https://github.com/rausi/RausiPool/wiki

---
Below are **guide for script files** to help momitor stakepool. Note! You have to modify files to be compatible with your own settings e.g. port number. **Use at your own risk.**

Cardano/Ada Donation address: _DdzFFzCqrht2jaj8hErzXYir6SMKeAmQKXzmVpoXnahCoJwC3ZmqkznvJ2gyBVVaH1q2PFkixm9JEBRFiprE2oC8pWiaccyxDWTg3Q31_

OR delegate some ADA to my stakepool (currently Incentivized Testnet phase)
***
# 1. nodestart.sh script guide (Ubuntu 18.04.3 LTS)
**Script nodestart can be started ssh or ubuntu parameter**<br>
**Script restart jormungandr if stuck_notifier existing**<br>
**Script restart jormungandr if it is not running**<br>
1. mkdir logs to same directory than your jcli and jormungandr 
2. Copy files **nodestart.sh, jstartssh.sh, jstartubuntu.sh** to same directory than your jcli and jormungandr
3. Edit files jstartssh.sh and/or jstartubuntu.sh.<br> 
  3.1. Define **POLL_TIME, CONFIG_FILE, SECRET_FILE and PORT**.
4. Edit your config files<br>
  4.1. if you start script using ubuntu parameter then make sure that you have defined output to file in your config file. NOTE ssh parameter do not need output file option.<br> 
  4.2. See config examples **ssh-config.yaml and/or ubuntu-config.yaml**<br>
  4.3. Use parameter no_blockchain_updates_warning_interval to define stuck_notifier time e..g. **"no_blockchain_updates_warning_interval": "30m"**
5. Start nodestart script using parameter ssh or ubuntu e.g. **./nodestart.sh ssh** or **./nodestart.sh ubuntu**<br>
  5.1 ssh parameter use nohup and jorgumgandr is started backgroud. This can be used with ssh connection eg. using PuTTY.<br>
  5.2 ubuntu parameter can be used only with Ubuntu GUI. Useful e.g. if you are doing some testing. I'm using log info level for ubuntu parameter and log warn level for ssh parameter. This is reason why 2 different config files.<br>
  5.3 if you start without parameter then ssh option is used.
  
---
# 2. jstart_stuck.sh script guide (Ubuntu 18.04.3 LTS)
**Script jstart_stuck restart jormungundr if stuck_notifier exists in log file**<br>
**this is older script and it is replaced with newer nodestart script.**<br> 
1. mkdir logs to same directory than your jcli and jormungandr
2. Make sure you have added also output to file in your itn_rewards_v1-config.yaml file<br>
  2.1. "log": [
    {
      "format": "plain",
      "level": "info",
      "output": "stderr",   
    },
    {
      "output": {
        "file": "/home/<username>/<dir>/logs/test.log"
        },
      "level": "info",
      "format": "plain",
    },
  ],
3. copy jstart_stuck.sh file to same directory than your jcli and jormungandr
4. Edit file. Check port number and define sleep time etc.
5. Run command: chmod +x jstart_stuck.sh
6. Start script: ./jstart_stuck.sh (Note! second terminal window is opened. Do not close windows)<br>
  6.1. You can see log in terminal but log is also wrote to file.
7. Check log file status if needed: cat ./logs/test.log (!Note open new terminal window)
_If you need to stop script press ctrl+c_

![Distribution](https://github.com/rausi/RausiPool/blob/master/stuck_notifier.png)

---
