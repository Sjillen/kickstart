import web3 from './web3';
import CampaignFactory from './build/CampaignFactory.json';

const instance = new web3.eth.Contract(JSON.parse(
    CampaignFactory.interface),
    '0xb57a22E109381A87E5CF79cea639F4B60E1eFc49'
    );

export default instance;
