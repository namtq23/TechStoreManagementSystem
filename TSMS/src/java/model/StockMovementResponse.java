package model;

import java.security.Timestamp;
import java.util.Date;

public class StockMovementResponse {
    private int responseID;
    private int movementID;
    private int responsedBy;
private Timestamp responseAt;

  public StockMovementResponse(int responseID, int movementID, int responsedBy, Timestamp responseAt, String responseStatus, String note) {
        this.responseID = responseID;
        this.movementID = movementID;
        this.responsedBy = responsedBy;
        this.responseAt = responseAt;
        this.responseStatus = responseStatus;
        this.note = note;
    }



    public String getResponseStatus() {
        return responseStatus;
    }

public Timestamp getResponseAt() {
    return responseAt;
}

public void setResponseAt(Timestamp responseAt) {
    this.responseAt = responseAt;
}

    private String responseStatus;
    private String note;

   

    public int getResponseID() {
        return responseID;
    }

    public void setResponseID(int responseID) {
        this.responseID = responseID;
    }

    public int getMovementID() {
        return movementID;
    }

    public void setMovementID(int movementID) {
        this.movementID = movementID;
    }

    public int getResponsedBy() {
        return responsedBy;
    }

    public void setResponsedBy(int responsedBy) {
        this.responsedBy = responsedBy;
    }

  

    public void setResponseStatus(String responseStatus) {
        this.responseStatus = responseStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
