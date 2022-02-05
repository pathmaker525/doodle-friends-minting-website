import { CHAIN_ID } from "."

const { ETH_MAINNET, ETH_TESTNET } = CHAIN_ID

export const contractAddresses = {
  [ETH_MAINNET]: {
    address: "0xa9a8317f1B8E24ef6E9d558085Afd2081D3d25E6",
    explorerUrl:
      "https://rinkeby.etherscan.io/token/0xa9a8317f1B8E24ef6E9d558085Afd2081D3d25E6",
  },
  [ETH_TESTNET]: {
    address: "0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
    explorerUrl:
      "https://rinkeby.etherscan.io/token/0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
  },
}
