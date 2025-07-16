/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class Shift {

    private int shiftID;
    private String shiftName;
    private LocalTime startTime;
    private LocalTime endTime;

    // Constructor mặc định
    public Shift() {
    }

    // Constructor với tham số
    public Shift(int shiftID, String shiftName, LocalTime startTime, LocalTime endTime) {
        this.shiftID = shiftID;
        this.shiftName = shiftName;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Constructor không có ID (cho việc tạo mới)
    public Shift(String shiftName, LocalTime startTime, LocalTime endTime) {
        this.shiftName = shiftName;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getter và Setter
    public int getShiftID() {
        return shiftID;
    }

    public void setShiftID(int shiftID) {
        this.shiftID = shiftID;
    }

    public String getShiftName() {
        return shiftName;
    }

    public void setShiftName(String shiftName) {
        this.shiftName = shiftName;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    // Phương thức tiện ích để format thời gian
    public String getFormattedStartTime() {
        return startTime != null ? startTime.format(DateTimeFormatter.ofPattern("HH:mm")) : "";
    }

    public String getFormattedEndTime() {
        return endTime != null ? endTime.format(DateTimeFormatter.ofPattern("HH:mm")) : "";
    }

    // Phương thức tính thời gian ca làm việc
    public String getShiftDuration() {
        if (startTime != null && endTime != null) {
            long hours = java.time.Duration.between(startTime, endTime).toHours();
            long minutes = java.time.Duration.between(startTime, endTime).toMinutes() % 60;
            return String.format("%d giờ %d phút", hours, minutes);
        }
        return "";
    }

    // Override toString để debug
    @Override
    public String toString() {
        return "Shift{"
                + "shiftID=" + shiftID
                + ", shiftName='" + shiftName + '\''
                + ", startTime=" + startTime
                + ", endTime=" + endTime
                + '}';
    }
}
