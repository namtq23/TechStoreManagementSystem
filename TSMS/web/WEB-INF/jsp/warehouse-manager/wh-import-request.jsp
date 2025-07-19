<%-- 
    Document   : wh-import-request
    Created on : Jul 14, 2025, 5:21:37 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.Announcement" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TSMS - Hệ thống thông báo</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/header.css"/>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f5f5f5;
                color: #333;
            }

            /* Main container */
            .main-container {
                display: flex;
                height: 100vh;
                padding-top: 70px;
                gap: 10px;
                padding: 30px 60px 30px 60px;
            }

            /* Left section (2/3 width) */
            .left-section {
                flex: 2;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }

            /* Right section (1/3 width) */
            .right-section {
                flex: 1;
                display: flex;
                flex-direction: column;
            }

            /* Chat boxes */
            .chat-box {
                background: white;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border: 1px solid #e0e6ed;
                overflow: hidden;
            }

            .chat-header {
                color: black;
                padding: 15px 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* Compose message box */
            .compose-box {
                flex: 1;
                min-height: 200px;
            }

            .compose-content {
                padding: 20px;
                height: calc(100% - 60px);
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .input-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
            }

            .input-group label {
                font-weight: 500;
                color: #333;
            }

            .input-group input, .input-group textarea {
                padding: 12px;
                border: 2px solid #e0e6ed;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s;
            }

            .input-group input:focus, .input-group textarea:focus {
                outline: none;
                border-color: #667eea;
            }

            .message-textarea {
                resize: vertical;
                min-height: 80px;
                flex: 1;
            }

            .send-button {
                background: #2196F3;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 500;
                transition: transform 0.2s;
                align-self: flex-end;
                margin-top: 20px;
            }

            .send-button:hover {
                transform: translateY(-2px);
            }

            /* Sent messages box */
            .sent-messages {
                flex: 1;
                min-height: 200px;
            }

            .messages-content {
                padding: 20px;
                height: calc(100% - 60px);
                overflow-y: auto;
            }

            /* Received messages box */
            .received-messages {
                flex: 1;
            }

            /* Message styles */
            .message {
                margin-bottom: 15px;
                padding: 12px 16px;
                border-radius: 12px;
                border-left: 4px solid;
                background: #f8f9fa;
            }

            .message.sent {
                border-left-color: #667eea;
                background: linear-gradient(135deg, #f8f9ff 0%, #e6f2ff 100%);
            }

            .message.received {
                border-left-color: #28a745;
                background: linear-gradient(135deg, #f8fff8 0%, #e6ffe6 100%);
            }

            .message.system {
                border-left-color: #ffc107;
                background: linear-gradient(135deg, #fffbf0 0%, #fff3cd 100%);
            }

            .message-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 8px;
            }

            .message-sender {
                font-weight: 600;
                color: #333;
            }

            .message-time {
                font-size: 12px;
                color: #666;
            }

            .message-content {
                color: #444;
                line-height: 1.4;
            }

            .message-title {
                font-weight: 500;
                color: #333;
                margin-bottom: 4px;
            }

            /* Scrollbar styles */
            .messages-content::-webkit-scrollbar {
                width: 6px;
            }

            .messages-content::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 3px;
            }

            .messages-content::-webkit-scrollbar-thumb {
                background: #c1c1c1;
                border-radius: 3px;
            }

            .messages-content::-webkit-scrollbar-thumb:hover {
                background: #a8a8a8;
            }

            /* Empty state */
            .empty-state {
                text-align: center;
                color: #666;
                padding: 40px 20px;
            }

            .empty-state i {
                font-size: 48px;
                color: #ddd;
                margin-bottom: 15px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    flex-direction: column;
                    gap: 10px;
                }

                .left-section {
                    flex: none;
                    height: 60vh;
                }

                .right-section {
                    flex: none;
                    height: 35vh;
                }

                .compose-box {
                    min-height: 150px;
                }

                .sent-messages {
                    min-height: 150px;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
          <header class="header">
            <div class="header-container">
                <div class="logo">
                    <a href="wh-products?page=1" class="logo">
                        <div class="logo-icon">T</div>
                        <span class="logo-text">TSMS</span>
                    </a>
                </div>
                <nav class="main-nav">
                    <a href="wh-products?page=1" class="nav-item ">
                        <i class="fas fa-box"></i>
                        Hàng hóa
                    </a>

                    <a href="wh-import" class="nav-item ">
                        <i class="fa-solid fa-download"></i>
                        Nhập hàng
                    </a>

                    <a href="wh-export" class="nav-item">
                        <i class="fa-solid fa-upload"></i>
                        Xuất hàng
                    </a>

                    <a href="wh-import-request" class="nav-item active">
                        <i class="fas fa-exchange-alt"></i>
                        Yêu cầu nhập hàng
                    </a>

                </nav>

                <div class="header-right">
                    <div class="user-dropdown">
                        <a href="" class="user-icon gradient" id="dropdownToggle">
                            <i class="fas fa-user-circle fa-2x"></i>
                        </a>
                        <div class="dropdown-menu" id="dropdownMenu">
                            <a href="staff-information" class="dropdown-item">Thông tin chi tiết</a>
                            <a href="logout" class="dropdown-item">Đăng xuất</a>
                        </div>
                    </div>      
                </div>
            </div>
        </header>

        <!-- Main Container -->
        <div class="main-container">
            <%
    String successMessage = (String) session.getAttribute("successMessage");
    if (successMessage != null) {
            %>
            <div id="toastMessage" style="
                 position: fixed;
                 top: 20px;
                 right: 20px;
                 background-color: #d4edda;
                 color: #155724;
                 padding: 12px 20px;
                 border-radius: 8px;
                 box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                 z-index: 9999;
                 font-weight: 500;
                 display: flex;
                 align-items: center;
                 gap: 10px;
                 animation: slideIn 0.4s ease-out;
                 ">
                <i class="fas fa-check-circle"></i> <%= successMessage %>
            </div>

            <script>
                // Tự động ẩn sau 3 giây
                setTimeout(() => {
                    const toast = document.getElementById("toastMessage");
                    if (toast)
                        toast.style.display = "none";
                }, 3000);
            </script>

            <style>
                @keyframes slideIn {
                    from {
                        opacity: 0;
                        transform: translateX(100%);
                    }
                    to {
                        opacity: 1;
                        transform: translateX(0);
                    }
                }
            </style>
            <%
                    session.removeAttribute("successMessage"); // Xoá sau khi hiển thị
                }
            %>

            <!-- Left Section (2/3) -->
            <div class="left-section">
                <!-- Compose Message Box -->
                <div class="chat-box compose-box">
                    <div class="chat-header">
                        <i class="fas fa-edit"></i>
                        Soạn thông báo
                    </div>
                    <div class="compose-content">
                        <form method="post" action="wh-import-request">
                            <div class="input-group">
                                <label for="messageTitle">Tiêu đề:</label>
                                <input type="text" id="messageTitle" name="title" placeholder="Nhập tiêu đề thông báo...">
                            </div>
                            <div class="input-group">
                                <label for="messageContent">Nội dung:</label>
                                <textarea id="messageContent" class="message-textarea" name="description" placeholder="Nhập nội dung thông báo..."></textarea>
                            </div>
                            <button class="send-button" onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i>
                                Gửi thông báo
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Sent Messages Box -->
                <div class="chat-box sent-messages">
                    <div class="chat-header">
                        <i class="fas fa-paper-plane"></i>
                        Thông báo đã gửi
                    </div>
                    <div class="messages-content" id="sentMessages">
                        <c:choose>
                            <c:when test="${empty sentList}">
                                <div class="empty-state">
                                    <i class="fas fa-paper-plane"></i>
                                    Bạn chưa gửi thông báo nào.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="a" items="${sentList}">
                                    <div class="message sent">
                                        <div class="message-header">
                                            <span class="message-sender">Tôi</span>
                                            <span class="message-time">
                                                <fmt:formatDate value="${a.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                                            </span>
                                        </div>
                                        <div class="message-title">${a.title}</div>
                                        <div class="message-content">${a.description}</div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Right Section (1/3) -->
            <div class="right-section">
                <div class="chat-box received-messages">
                    <div class="chat-header">
                        <i class="fas fa-inbox"></i>
                        Thông báo nhận được
                    </div>
                    <div class="messages-content" id="receivedMessages">
                        <c:choose>
                            <c:when test="${empty receivedList}">
                                <div class="empty-state">
                                    <i class="fas fa-inbox"></i>
                                    Không có thông báo nào.
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="a" items="${receivedList}">
                                    <div class="message received">
                                        <div class="message-header">
                                            <span class="message-sender">${a.fromUser}</span>
                                            <span class="message-time">
                                                <fmt:formatDate value="${a.createdAt}" pattern="HH:mm dd/MM/yyyy" />
                                            </span>
                                        </div>
                                        <div class="message-title">${a.title}</div>
                                        <div class="message-content">${a.description}</div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // User dropdown functionality
            const toggle = document.getElementById("dropdownToggle");
            const menu = document.getElementById("dropdownMenu");

            toggle.addEventListener("click", function (e) {
                e.preventDefault();
                menu.style.display = menu.style.display === "block" ? "none" : "block";
            });

            document.addEventListener("click", function (e) {
                if (!toggle.contains(e.target) && !menu.contains(e.target)) {
                    menu.style.display = "none";
                }
            });


            // Add enter key support for sending messages
            document.getElementById('messageContent').addEventListener('keydown', function (e) {
                if (e.ctrlKey && e.key === 'Enter') {
                    sendMessage();
                }
            });

            // Auto-resize textarea
            document.getElementById('messageContent').addEventListener('input', function () {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            // Send message functionality
            function sendMessage() {
                const title = document.getElementById('messageTitle').value;
                const content = document.getElementById('messageContent').value;

                if (!title.trim() || !content.trim()) {
                    alert('Vui lòng nhập đầy đủ tiêu đề và nội dung!');
                    return;
                }
            }
        </script>
    </body>
</html>
