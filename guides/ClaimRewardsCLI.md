# 1.Check rewards from stake address (stake.addr)

cardano-cli shelley query stake-address-info --address $(cat stake.addr) --mainnet

or

cardano-cli shelley query stake-address-info --cardano-mode --address stake1uwedfxxxu5dhwqsr3rtyyxyertyq2vg4wtx3j68u0mpd8gcj39123 --mainnet

##output looks like this##<br>
[
    {
        "address": "stake1uwedfxxxu5dhwqsr3rtyyxyertyq2vg4wtx3j68u0mpd8gcj39123",
        "delegation": "pool34gh6h526rcp836t6l94zk5rtyulp4tvrq87xlnthzagwjyhzxcv",
        "rewardAccountBalance": 380171658
    }
]

# 2. Get the transaction hash and index of the UTXO to spend
You need pay address (payment.addr) to pay transaction fees + rewards will be moved to this address in this example

cardano-cli shelley query utxo --address $(cat payment.addr) --mainnet

or

cardano-cli shelley query utxo --address addr1rtyulhxxxp7c8tyuiopjdus7fdk9p2twg75c54678znns88cy7fayst6kw6m8jr4hgfqwertcgfkwhtgfn02p8mgzesr567jk --mainnet

##output looks like this##<br>
                           TxHash                                 TxIx        Lovelace
----------------------------------------------------------------------------------------
468dd0d6ca0ea96c882e8b0733c1b74ef6a28548a58c27597d4c12d9004228e     1        2000000000
48a3eb92a77a611995076f5b706689119ff69d177e6f465db92c1b94c2fc5b8     0        1615847681

# 3. Create draft transaction. Add stake address+rewards after --withdrawal 
cardano-cli shelley transaction build-raw \
--tx-in 48a3eb92a77a611995076f5b706689119ff69d177e6f465db92c1b94c2fc5b8#0 \
--tx-out $(cat payment.addr)+0 \
--ttl 0 \
--fee 0 \
--withdrawal stake1uwedfxxxu5dhwqsr3rtyyxyertyq2vg4wtx3j68u0mpd8gcj39123+380171658 \
--out-file rewards.raw

# 4. calculate fee
cardano-cli shelley transaction calculate-min-fee \
--tx-body-file rewards.raw \
--mainnet \
--tx-in-count 1 \
--tx-out-count 1 \
--witness-count 2 \
--byron-witness-count 0 \
--protocol-params-file protocol.json

##output looks like this##<br>
>179141 Lovelace

# 5. Calculate the change to send back to payment.addr
formula --> UTXO amount - fee + rewards<br> 
1615847681-179141+380171658=1995840198

# 6. Determine the TTL (time to Live) for the transaction
cardano-cli shelley query tip --mainnet

##output looks like this##<br>
"slotNo":6724030

formula --> slotNO + 400 slots<br> 
6724030+400=6724430

# 7. Build the transaction
cardano-cli shelley transaction build-raw \
--tx-in 48a3eb92a77a611995076f5b706689119ff69d177e6f465db92c1b94c2fc5b8#0 \
--tx-out $(cat payment.addr)+1995840198 \
--ttl 6724430 \
--fee 179141 \
--withdrawal stake1uwedfxxxu5dhwqsr3rtyyxyertyq2vg4wtx3j68u0mpd8gcj39123+380171658 \
--out-file rewards.raw

# 7. Sign and submit transaction
cardano-cli shelley transaction sign \
--tx-body-file rewards.raw \
--signing-key-file payment.skey \
--signing-key-file stake.skey \
--mainnet \
--out-file rewards.signed

And submit it:

cardano-cli shelley transaction submit \
--tx-file rewards.signed \
--mainnet
