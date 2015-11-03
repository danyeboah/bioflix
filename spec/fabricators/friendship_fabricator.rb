Fabricator(:friendship) do  
  leader {Fabricate(:user)}
  follower {Fabricate(:user)}
end