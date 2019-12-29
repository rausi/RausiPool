# RausiPool
![Distribution](https://github.com/rausi/RausiPool/blob/master/RausiPool.PNG)

**Cardano staking pool information**<br>
Please see https://github.com/rausi/RausiPool/wiki

---
Below are guide for some script files to help maintain stakepool. Note! You have to modify files to be compatible with your own settings e.g. port number. **Use at your own risk.**

Cardano/Ada Donation address: _DdzFFzCqrht2jaj8hErzXYir6SMKeAmQKXzmVpoXnahCoJwC3ZmqkznvJ2gyBVVaH1q2PFkixm9JEBRFiprE2oC8pWiaccyxDWTg3Q31_

OR delegate ADA to my stakepool (currently Incentivized Testnet phase)

---
# jstart_stuck.sh script guide (Ubuntu 18.04.3 LTS)
**Restart jormungundr if stuck_notifier exists in log file**
1. mkdir logs to same directory than your jcli and jormungandr
2. Make sure you have line also output to file in your itn_rewards_v1-config.yaml file<br>
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
6. Start script: ./jstart_stuck.sh (Note! second terminal window is opened. Do not close windows)
7. check log file status if needed: cat ./logs/test.log (!Note open new terminal window)
_If you need to stop script press ctrl+c_

![Distribution](https://github.com/rausi/_LowFeeStake/blob/master/stuck_notifier.PNG)

---

