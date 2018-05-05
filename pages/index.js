import React from 'react';
import factory from '../ethereum/factory';

class CampaignIndex extends React.Component {
    // lifecycle specific to nextJS for server-side data fetching
    static async getInitialProps() {
        const campaigns = await factory.methods.getDeployedCampaigns().call();
        //return campaigns object as props
        return { campaigns };
    }

    render() {
        return <div>{this.props.campaigns[0]}</div>;
    }
}

export default CampaignIndex;