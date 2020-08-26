# 1. Add ITN keys to file (secret and public) if not yet available
```
echo "ed25519e_sk1....." > itn.skey
```
```
echo "ed25519_pk1....." > itn.vkey
```
# 2. convert itn keys
**secret key**<br>
If you have entended key "ed25519e_sk1..." then use this command (needs cardano-cli version 1.19.0)
```
cardano-cli  shelley key convert-itn-extended-key --itn-signing-key-file itn.skey --out-file itn.staking.skey
```
otherwise use this command (ed25519_sk1...)
```
cardano-cli  shelley key convert-itn-key --itn-signing-key-file itn.skey --out-file itn.staking.skey
```
**public key**<br>
```
cardano-cli shelley key convert-itn-key --itn-verification-key-file itn.vkey --out-file itn.staking.vkey
```
# 3. Create stake address
```
shelley stake-address build --staking-verification-key-file itn.staking.vkey --out-file itn_stake.addr --mainnet
```
# 4. Claim rewards
Follow guide https://github.com/rausi/RausiPool/blob/master/guides/ClaimRewardsCLI.md <br>
Use itn_stake.addr as your stake address and sign transaction using itn.staking.skey
