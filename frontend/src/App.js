import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import StartPage from "./pages/StartPage";
import Login from "./pages/Login";
import Register from "./pages/Register";
import CreateAccount from "./pages/CreateAccount";
import MatchingPage from "./pages/MatchingPage";
import Messages from "./pages/Messages";
import ChatPage from "./pages/ChatPage";

function App() {
    return (
        <Router>
            <Routes>
                <Route path="/" element={<StartPage />} />
                <Route path="/login" element={<Login />} />
                <Route path="/register" element={<Register />} />
                <Route path="/create-account" element={<CreateAccount />} />
                <Route path="/matching" element={<MatchingPage />} />
                <Route path="/messages" element={<Messages />} />
                <Route path="/chat" element={<ChatPage />} />
            </Routes>
        </Router>
    );
}

export default App;
