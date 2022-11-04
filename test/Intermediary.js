const NeoToken = artifacts.require('NeoToken')
const USDTJ = artifacts.require('USDTJ')
const Intermediary = artifacts.require('Intermediary')

require('chai')
    .use(require('chai-as-promised'))
    .should()

contract('Intermediary', ([owner, customer]) => {
    let neoToken, usdtj, intermediary

    function tokens(number) {
        return web3.utils.toWei(number, 'ether')
    }

    before(async () => {
        // Load Contracts
        usdtj = await USDTJ.new()
        neoToken = await NeoToken.new()
        intermediary = await Intermediary.new(neoToken.address, usdtj.address)

        // Transfer all tokens to DecentralBank (1 million)
        await neoToken.transfer(intermediary.address, tokens('1000000'))

        // Transfer 100 mock Tethers to Customer
        await usdtj.transfer(customer, tokens('100'), { from: owner })
    })


    describe('USDTJ Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await usdtj.name()
            assert.equal(name, 'USDTJ')
        })
    })

    describe('NeoToken Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await neoToken.name()
            assert.equal(name, 'NeoToken')
        })
    })

    describe('Intermediary Deployment', async () => {
        it('matches name successfully', async () => {
            const name = await intermediary.name()
            assert.equal(name, 'Intermediary')
        })

        it('contract has tokens', async () => {
            let balance = await neoToken.balanceOf(intermediary.address)
            assert.equal(balance.toString(), '1000000000000000000000000')
        })
        describe('Yield Farming', async () => {
            it('rewards tokens for staking', async () => {
                let result

                // Check Investor Balance
                result = await usdtj.balanceOf(customer)
                assert.equal(result.toString(), tokens('100'), 'customer mock wallet balance before staking')

                // Check Staking For Customer of 100 tokens
                await usdtj.approve(intermediary.address, tokens('100'), { from: customer })
                await intermediary.depositToken(tokens('100'), { from: customer })
                // Check Updated Balance of Customer
                result = await usdtj.balanceOf(customer)
                assert.equal(result.toString(), tokens('0'), 'customer mock wallet balance after staking 100 tokens')

                // Check Updated Balance
                result = await usdtj.balanceOf(intermediary.address)
                assert.equal(result.toString(), tokens('100'), 'intermediary  wallet balance after staking from customer')


            })
        })
    })
})



