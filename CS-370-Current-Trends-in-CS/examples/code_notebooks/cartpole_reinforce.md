# Cartpole REINFORCE Implementation

## Overview
Implementation of REINFORCE algorithm for the Cartpole environment using OpenAI Gym.

## Algorithm Components
1. **Policy Network**
   - Neural network that outputs action probabilities
   - Softmax activation for probability distribution

2. **REINFORCE Algorithm**
   - Monte Carlo policy gradient method
   - Updates policy based on episode returns

3. **Training Loop**
   - Collect episodes
   - Calculate discounted returns
   - Update policy network

## Installation and Setup

```python
# Install required packages
# !pip install gym torch numpy matplotlib
```

```python
import gym
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
import numpy as np
import matplotlib.pyplot as plt
from collections import deque
```

## Policy Network Implementation

```python
class PolicyNetwork(nn.Module):
    """Policy network that outputs action probabilities"""
    
    def __init__(self, state_dim, action_dim, hidden_dim=128):
        super(PolicyNetwork, self).__init__()
        self.fc1 = nn.Linear(state_dim, hidden_dim)
        self.fc2 = nn.Linear(hidden_dim, action_dim)
    
    def forward(self, state):
        """Forward pass through the network"""
        x = F.relu(self.fc1(state))
        return F.softmax(self.fc2(x), dim=-1)
    
    def get_action(self, state):
        """Sample an action from the policy"""
        state = torch.FloatTensor(state).unsqueeze(0)
        probs = self.forward(state)
        action = torch.multinomial(probs, 1)
        return action.item(), probs[0, action.item()].item()
```

## REINFORCE Algorithm Implementation

```python
class REINFORCE:
    """REINFORCE algorithm for policy gradient learning"""
    
    def __init__(self, state_dim, action_dim, lr=0.01, gamma=0.99):
        self.policy = PolicyNetwork(state_dim, action_dim)
        self.optimizer = optim.Adam(self.policy.parameters(), lr=lr)
        self.gamma = gamma
        self.saved_log_probs = []
        self.rewards = []
    
    def select_action(self, state):
        """Select action using current policy"""
        state = torch.FloatTensor(state)
        probs = self.policy(state)
        m = torch.distributions.Categorical(probs)
        action = m.sample()
        self.saved_log_probs.append(m.log_prob(action))
        return action.item()
    
    def update_policy(self):
        """Update policy using episode returns"""
        R = 0
        policy_loss = []
        returns = deque()
        
        # Calculate discounted returns
        for r in self.rewards[::-1]:
            R = r + self.gamma * R
            returns.appendleft(R)
        
        returns = torch.tensor(returns)
        returns = (returns - returns.mean()) / (returns.std() + 1e-9)  # Normalize
        
        # Calculate policy loss
        for log_prob, R in zip(self.saved_log_probs, returns):
            policy_loss.append(-log_prob * R)
        
        # Update policy
        self.optimizer.zero_grad()
        policy_loss = torch.cat(policy_loss).sum()
        policy_loss.backward()
        self.optimizer.step()
        
        # Clear episode data
        del self.rewards[:]
        del self.saved_log_probs[:]
```

## Training Function

```python
def train_reinforce(env, agent, num_episodes=1000, max_steps=500):
    """Train the REINFORCE agent"""
    scores = []
    score_window = deque(maxlen=100)
    
    for episode in range(num_episodes):
        state = env.reset()
        episode_reward = 0
        
        for step in range(max_steps):
            action = agent.select_action(state)
            state, reward, done, _ = env.step(action)
            agent.rewards.append(reward)
            episode_reward += reward
            
            if done:
                break
        
        agent.update_policy()
        scores.append(episode_reward)
        score_window.append(episode_reward)
        
        if (episode + 1) % 100 == 0:
            avg_score = np.mean(score_window)
            print(f'Episode {episode + 1}, Average Score: {avg_score:.2f}')
            if avg_score >= 195.0:
                print(f'Environment solved in {episode + 1} episodes!')
                break
    
    return scores
```

## Main Training Script

```python
# Create environment
env = gym.make('CartPole-v1')
state_dim = env.observation_space.shape[0]
action_dim = env.action_space.n

# Initialize agent
agent = REINFORCE(state_dim, action_dim, lr=0.01, gamma=0.99)

# Train agent
print("Starting REINFORCE training...")
scores = train_reinforce(env, agent, num_episodes=1000)

# Close environment
env.close()
```

## Visualization

```python
def plot_training_progress(scores):
    """Plot training progress"""
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Plot episode scores
    ax.plot(scores, alpha=0.6, label='Episode Score', color='blue')
    
    # Plot moving average
    if len(scores) >= 100:
        window_size = 100
        moving_avg = np.convolve(scores, np.ones(window_size)/window_size, mode='valid')
        ax.plot(range(window_size-1, len(scores)), moving_avg, 
                label='100-Episode Average', color='red', linewidth=2)
    
    ax.set_xlabel('Episode')
    ax.set_ylabel('Score')
    ax.set_title('REINFORCE Training Progress - CartPole')
    ax.legend()
    ax.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.show()

# Plot results
plot_training_progress(scores)
```

## Testing the Trained Agent

```python
def test_agent(env, agent, num_episodes=10):
    """Test the trained agent"""
    total_rewards = []
    
    for episode in range(num_episodes):
        state = env.reset()
        episode_reward = 0
        
        while True:
            # Use policy to select action (no exploration)
            state_tensor = torch.FloatTensor(state)
            probs = agent.policy(state_tensor)
            action = torch.argmax(probs).item()
            
            state, reward, done, _ = env.step(action)
            episode_reward += reward
            
            if done:
                break
        
        total_rewards.append(episode_reward)
        print(f'Test Episode {episode + 1}: Reward = {episode_reward}')
    
    avg_reward = np.mean(total_rewards)
    print(f'\nAverage Test Reward: {avg_reward:.2f}')
    return total_rewards

# Test the trained agent
env_test = gym.make('CartPole-v1')
test_rewards = test_agent(env_test, agent, num_episodes=10)
env_test.close()
```

## Results Analysis
- Episode rewards over training
- Policy convergence
- Comparison with random baseline

## Key Hyperparameters

```python
# Hyperparameter configuration
config = {
    'learning_rate': 0.01,
    'gamma': 0.99,
    'hidden_dim': 128,
    'num_episodes': 1000,
    'max_steps': 500
}

print("Hyperparameters:")
for key, value in config.items():
    print(f"  {key}: {value}")
```

## Ethical Implications
- AI decision-making in control systems
- Safety considerations for autonomous systems
- Need for robust testing and validation before deployment
