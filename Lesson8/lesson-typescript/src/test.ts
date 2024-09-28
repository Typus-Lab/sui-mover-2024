import { SuiClient } from "@mysten/sui/client";
import { Transaction } from "@mysten/sui/transactions";
import { BcsReader } from "@mysten/bcs";

(async () => {
    let provider = new SuiClient({ url: "https://fullnode.testnet.sui.io:443" });
    let transaction = new Transaction();
    let packageId = "0x0d0b8de6834045f24acae61d09c2e655aede6a6d926c361bdabcc7b34d057870";
    let registry = "0xeb66e96624adbb278053709fe8821c4277947c157e4f487b4d69b1c8f8c859bf";
    transaction.moveCall({
        target: `${packageId}::main::get_chimera_bcs`,
        typeArguments: [],
        arguments: [transaction.object(registry)],
    });
    let results = (
        await provider.devInspectTransactionBlock({
            transactionBlock: transaction,
            sender: "0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        })
    ).results;
    // @ts-ignore
    let bytes = results[results.length - 1].returnValues[0][0];
    console.log(JSON.stringify(bytes));
    let reader = new BcsReader(new Uint8Array(bytes));
    let result = reader.readVec((reader) => {
        reader.readULEB();
        let id = AddressFromBytes(reader.readBytes(32));
        let a = reader.read8();
        let b = reader.read16();
        let c = reader.read32();
        let d = reader.read64();
        let e = reader.read8() == 1;
        let f = reader.readVec((reader) => {
            return reader.read8();
        });

        return {
            id,
            a,
            b,
            c,
            d,
            e,
            f,
        };
    });
    console.log(result);
})();

function AddressFromBytes(x: Uint8Array) {
    var address = "0x";
    for (var i = 0; i < x.length; i++) {
        address = address.concat(x[i].toString(16).padStart(2, "0"));
    }
    return address;
}
