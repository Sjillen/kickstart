import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(JSON.parse(
    CampaignFactory.interface),
    '0x41273577b1d8f6b5f8804B48fF234D38c388e64E'
    );

export default instance;
