// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearningPlatform {
    // Define a struct to hold user information
    struct User {
        uint256 tokens;
        uint256 completedVideos;
        uint256 completedAssignments;
        bool[] topicsUnlocked; // Boolean array to track unlocked topics
    }

    // Mapping from user addresses to their information
    mapping(address => User) public users;

    // Define the cost to unlock new topics and assignments
    uint256 public videoTokenReward = 10; // Tokens rewarded per video
    uint256 public assignmentTokenReward = 20; // Tokens rewarded per assignment
    uint256 public unlockCost = 50; // Tokens required to unlock a new topic

    // Event declarations
    event TokensEarned(address indexed user, uint256 amount);
    event TopicUnlocked(address indexed user, uint256 topicId);
    event AssignmentCompleted(address indexed user, uint256 assignmentId);

    // Function to initialize a new user (usually called by an admin or during onboarding)
    function initializeUser(address userAddress, uint256 numberOfTopics) external {
        require(users[userAddress].topicsUnlocked.length > 0, "User already initialized");
        users[userAddress].topicsUnlocked = new bool[](numberOfTopics);
    }

    // Function to reward tokens for completing a video
    function completeVideo() external {
        users[msg.sender].tokens += videoTokenReward;
        users[msg.sender].completedVideos += 1;
        emit TokensEarned(msg.sender, videoTokenReward);
    }

    // Function to reward tokens for completing an assignment
    function completeAssignment() external {
        users[msg.sender].tokens += assignmentTokenReward;
        users[msg.sender].completedAssignments += 1;
        emit TokensEarned(msg.sender, assignmentTokenReward);
        emit AssignmentCompleted(msg.sender, users[msg.sender].completedAssignments);
    }

    // Function to unlock a new topic
    function unlockTopic(uint256 topicId) external {
        require(topicId < users[msg.sender].topicsUnlocked.length, "Invalid topic ID");
        require(!users[msg.sender].topicsUnlocked[topicId], "Topic already unlocked");
        require(users[msg.sender].tokens >= unlockCost, "Insufficient tokens");

        users[msg.sender].tokens -= unlockCost;
        users[msg.sender].topicsUnlocked[topicId] = true;
        emit TopicUnlocked(msg.sender, topicId);
    }

    // Function to check user status
    function getUserStatus(address userAddress) external view returns (uint256 tokens, uint256 completedVideos, uint256 completedAssignments, bool[] memory topicsUnlocked) {
        User memory user = users[userAddress];
        return (user.tokens, user.completedVideos, user.completedAssignments, user.topicsUnlocked);
    }
}
