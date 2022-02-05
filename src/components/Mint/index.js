import { FiPlusCircle, FiMinusCircle } from "react-icons/fi"
import { BannerImage } from "resources/Images"

import "./style.scss"

const Mint = ({ ticker = 535, totalSupply = 3353 }) => (
  <div className="mint flex">
    <div className="mint-wrapper container flex">
      <div className="mint-main card shadowed rounded flex flex-column">
        <img className="rounded-md" src={BannerImage} alt="banner" />
        <h3>Get your Doodle Friends</h3>
        <span className="mint-ticker">
          {ticker} / {totalSupply} Minted
        </span>
        <div className="mint-counter flex">
          <FiPlusCircle />
          <input type="number" className="rounded-sm" />
          <FiMinusCircle />
        </div>
        <div className="mint-button">
          <button className="rounded-sm">Mint</button>
        </div>
      </div>
    </div>
  </div>
)

export default Mint
