package model;

public class Branches {
    private int BranchID;
    private String BranchName;

    public Branches(int BranchID, String BranchName) {
        this.BranchID = BranchID;
        this.BranchName = BranchName;
    }

    public Branches() {
    }
    

    public int getBranchID() {
        return BranchID;
    }

    public void setBranchID(int BranchID) {
        this.BranchID = BranchID;
    }

    public String getBranchName() {
        return BranchName;
    }

    public void setBranchName(String BranchName) {
        this.BranchName = BranchName;
    }
}