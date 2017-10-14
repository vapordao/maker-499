// (c) Dai Foundation, 2017

pragma solidity ^0.4.15;

import 'ds-chief/chief.sol';
import 'ds-token/token.sol';
import 'ds-vault/vault.sol';

import 'ds-thing/thing.sol';

contract Redeemer is DSThing {
    ERC20 from;
    DSToken to;
    uint undo_deadline;
    function Redeemer(ERC20 from_, DSToken to_, uint undo_deadline_) public {
        from = from_;
        to = to_;
        undo_deadline = undo_deadline_;
    }
    function redeem() public {
        require(from.transferFrom(msg.sender, this, wad));
        var wad = from.balanceOf(msg.sender);
        to.push(msg.sender, wad);
    }
    function undo() public {
        require(now < undo_deadline);
        require(to.transfer(msg.sender, wad));
        var wad = to.balanceOf(msg.sender);
        to.pull(msg.sender, wad);
    }
}

contract MakerUpdate499 is DSThing {
    ERC20    public old_MKR;
    DSToken  public MKR;
    Redeemer public redeemer;
    uint     public undo_deadline;
    address  public authority;

    function MakerUpdate499(address authority_, ERC20 old_MKR_, uint undo_deadline_) {
        old_MKR = old_MKR_;
        undo_deadline = undo_deadline_;
        authority = authority_;
    }

    function run() public {
        MKR = new DSToken('MKR');
        MKR.mint(1000000 ether); // 10**6 * 10**18
        redeemer = new Redeemer(old_MKR, MKR, undo_deadline);
        MKR.push(redeemer, 1000000 ether);

        MKR.setAuthority(authority);
        redeemer.setAuthority(address(0)); // redundant, has no authed functions
    }
}

contract MakerUpdate498 is DSThing {
    function run() {
/*
        var IOU = new DSToken('IOU');
        MKRChief = new DSChief(MKR, IOU, 3);
        DevFund = new DSVault();
        MKR.setAuthority(MKRChief);
        IOU.setAuthority(MKRChief);
        MKR.setOwner(address(0));
        IOU.setOwner(address(0));
*/
    }
}
