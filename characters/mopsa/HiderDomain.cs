using FluidHTN;
using Godot;
using Godot.Collections;

public class HiderDomain
{
	public Domain<AIContext> Create()
	{
		return new DomainBuilder<AIContext>("BeHider")
		.Select("Hide")
			.Condition("At Hiding Spot", ctx => ctx.HasState(WorldState.AtHidingSpot, true))
		.End()
		.Select("Go To Hiding Spot")
			.Condition("Has Hiding Spot", ctx => ctx.HasState(WorldState.HidingSpotChosen, true))
			.Condition("NOT At Hiding Spot", ctx => ctx.HasState(WorldState.AtHidingSpot, false))
			.Action("Go To Hiding Spot")
				.ExecutingCondition("Has Hiding Spot", ctx => ctx.HasState(WorldState.HidingSpotChosen, true))
				.Do(ctx =>
				{
					if (ctx.Agent is Hider h)
					{
						GD.Print("Going to hiding spot!");
						Vector3 direction = ctx.CurrentPath[ctx.PathNode] - h.GlobalTransform.origin;

						var animationPlayer = h.GetNode<AnimationPlayer>("Model/AnimationPlayer");

						if (direction.Length() < 0.1)
						{
							ctx.PathNode += 1;

							if (ctx.PathNode == ctx.CurrentPath.Length)
							{
								ctx.HidingSpot.Call("use", h);
								GD.Print("At hiding spot!");

								return TaskStatus.Success;
							}
						}
						else
						{
							var velocity = direction.Normalized() * h.Speed;
							h.MoveAndSlide(velocity, Vector3.Up);
							h.LookAt(new Vector3(direction.x, h.GlobalTransform.origin.y, direction.z), Vector3.Up);
							if (!animationPlayer.IsPlaying())
							{
								animationPlayer.CurrentAnimation = "Run";
								animationPlayer.Play();
							}
						}

						if (!animationPlayer.IsPlaying())
						{
							animationPlayer.CurrentAnimation = "WalkBlink";
							animationPlayer.Play();
						}

						return TaskStatus.Continue;
					}

					return TaskStatus.Failure;
				})
				.Effect("At Hiding Spot", EffectType.PlanAndExecute, (ctx, type) => ctx.SetState(WorldState.AtHidingSpot, true, type))
			.End()
		.End()
		.Select("Choose Hiding Spot")
			.Condition("Player Eyes Are Closed", ctx => ctx.HasState(WorldState.PlayerEyesClosed, true))
			.Condition("Does NOT Have Hiding Spot", ctx => ctx.HasState(WorldState.HidingSpotChosen, false))
			.Action("Find Hiding Spot")
				.Do(ctx =>
				{
					// Choose a random hiding spot that the we can navigate to. 
					GD.Print("Choosing Hiding Spot");

					if (ctx.Agent is KinematicBody k)
					{
						Navigation navigation = k.GetTree().CurrentScene.GetNodeOrNull<Navigation>("Navigation");
						Array hidingSpots = k.GetTree().GetNodesInGroup("hiding_spots");

						if (navigation != null && hidingSpots.Count > 0)
						{
							GD.Print("Got navigation and hiding spots array");

							var random = new System.Random();
							int i = random.Next(0, hidingSpots.Count);

							var hidingSpot = hidingSpots[i];

							if (hidingSpot is StaticBody s && (hidingSpot != ctx.PreviousHidingSpot || hidingSpots.Count < 2))
							{
								GD.Print("Got hiding spot");

								var path = navigation.GetSimplePath(k.GlobalTransform.origin, s.GlobalTransform.origin);
								GD.Print(path);

								if (path.Length > 0)
								{
									GD.Print("Got path");

									ctx.HidingSpot = (StaticBody)hidingSpot;
									ctx.CurrentPath = path;
									ctx.PathNode = 0;

									GD.Print("Hiding Spot Chosen!");
									return TaskStatus.Success;
								}
							}
						}
					}

					GD.Print("Failed to choose hiding spot");
					return TaskStatus.Failure;
				})
				.Effect("Hiding Spot Chosen", EffectType.PlanAndExecute, (ctx, type) => ctx.SetState(WorldState.HidingSpotChosen, true, type))
			.End()
		.End()
		.Build();
	}
}
