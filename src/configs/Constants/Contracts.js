import { CHAIN_ID } from "."

const { ETH_MAINNET, ETH_TESTNET } = CHAIN_ID

export const contractAddresses = {
  [ETH_MAINNET]: {
    address: "0x1bd5cabea1ac7049093011c98bf8afe8b2482063",
    explorerUrl:
      "https://etherscan.io/token/0x1bd5cabea1ac7049093011c98bf8afe8b2482063",
  },
  [ETH_TESTNET]: {
    address: "0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
    explorerUrl:
      "https://rinkeby.etherscan.io/token/0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
  },
}
