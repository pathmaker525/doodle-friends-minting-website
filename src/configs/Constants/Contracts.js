import { CHAIN_ID } from "."

const { ETH_MAINNET, ETH_TESTNET } = CHAIN_ID

export const contractAddresses = {
  [ETH_MAINNET]: {
    address: "0x2FCf0ec9D6b575838aB77E6f567DA143A8560d6d",
    explorerUrl:
      "https://etherscan.io/token/0x2fcf0ec9d6b575838ab77e6f567da143a8560d6d",
  },
  [ETH_TESTNET]: {
    address: "0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
    explorerUrl:
      "https://rinkeby.etherscan.io/token/0x30C4Df9E5323B1844bA91573B4966E7Af9A93683",
  },
}
