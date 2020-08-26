# 1. Add ITN keys to file (secret and public)
echo "ed25519e_sk1....." > itn.skey
echo "ed25519_pk1....." > itn.skey

# 2. convert keys
**secret key**
If you have entended key "ed25519e_sk1" then use this command
cardano-cli  shelley key convert-itn-extended-key --itn-signing-key-file itn.skey --out-file itn.staking.skey

otherwise use this
cardano-cli  shelley key convert-itn-key --itn-signing-key-file itn.skey --out-file itn.staking.skey

**public key**
shelley key convert-itn-key --itn-verification-key-file itn.vkey --out-file itn.staking.vkey

# 3. Create stake address
shelley stake-address build --staking-verification-key-file itn.staking.vkey --out-file itn_stake.addr --mainnet

# 4. Claim rewards
Follow guide https://github.com/rausi/RausiPool/blob/master/guides/ClaimRewardsCLI.md
