// (c) Dai Foundation, 2017

pragma solidity ^0.4.15;

import 'ds-token/token.sol';
//import 'ds-vault/vault.sol';

import 'ds-thing/thing.sol';

contract Redeemer is DSStop {
    ERC20   public from;
    DSToken public to;
    uint    public undo_deadline;
    function Redeemer(ERC20 from_, DSToken to_, uint undo_deadline_) public {
        from = from_;
        to = to_;
        undo_deadline = undo_deadline_;
    }
    function redeem() public stoppable {
        var wad = from.balanceOf(msg.sender);
        require(from.transferFrom(msg.sender, this, wad));
        to.push(msg.sender, wad);
    }
    function undo() public stoppable {
        var wad = to.balanceOf(msg.sender);
        require(now < undo_deadline);
        require(from.transfer(msg.sender, wad));
        to.pull(msg.sender, wad);
    }
    function reclaim() public auth {
        require(stopped);
        var wad = from.balanceOf(this);
        require(from.transfer(msg.sender, wad));
        wad = to.balanceOf(this);
        to.push(msg.sender, wad);
    }
}

contract MakerUpdate499 is DSAuth {
    ERC20        public old_MKR;
    DSToken      public MKR;
    Redeemer     public redeemer;
    uint         public undo_deadline;

    function MakerUpdate499(address owner_
                           , ERC20 old_MKR_
                           , uint undo_deadline_
                           )
        public
    {
        old_MKR = old_MKR_;
        undo_deadline = undo_deadline_;
        owner = owner_;
    }

    function run() public {
        MKR = new DSToken('MKR');
        MKR.mint(1000000 ether); // 10**6 * 10**18
        redeemer = new Redeemer(old_MKR, MKR, undo_deadline);
        MKR.push(redeemer, 1000000 ether);

        redeemer.setOwner(owner);
        MKR.setOwner(owner);
    }
}

/*
contract MakerUpdate498 is DSThing {

    function run() public {
        var IOU = new DSToken('IOU');
        MKRChief = new DSChief(MKR, IOU, 3);
        DevFund = new DSVault();
        MKR.setAuthority(MKRChief);
        IOU.setAuthority(MKRChief);
        MKR.setOwner(address(0));
        IOU.setOwner(address(0));
    }
}
*/
