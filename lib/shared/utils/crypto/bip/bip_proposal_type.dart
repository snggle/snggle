enum BipProposalType {
   bip44(44),
   bip49(49),
   bip84(84);
   
    final int proposalNumber;
    
    const BipProposalType(this.proposalNumber);
}
