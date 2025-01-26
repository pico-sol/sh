#15行目のbytesはステークアカウントを持つウォレットのpubkey
curl https://api.mainnet-beta.solana.com -X POST -H "Content-Type: application/json" -d '
  {
    "jsonrpc": "2.0",
    "id": 1,
    "method": "getProgramAccounts",
    "params": [
      "Stake11111111111111111111111111111111111111",
      {
        "encoding": "jsonParsed",
        "filters": [
          {
            "memcmp": {
              "offset": 44,
              "bytes": "51XkcFsLZcw8fMDCNkCXx3tFdiXTukQVDAsbk8B5mSfc"
            }
          }
        ]
      }
    ]
  }
'