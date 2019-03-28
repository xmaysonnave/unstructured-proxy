const { expect } = require('chai');

const StringUtilMock = artifacts.require("StringUtilMock");

contract("StringUtil", function ([_, anyone]) {

    it("append", async () => {
        const test = await StringUtilMock.new({ from: anyone });
        expect(await test.appendTest()).to.equal(true);
    });

});