export default (sequelize, DataTypes) => {
  const StoryProblem = sequelize.define(
    "StoryProblem",
    {
      storyId: {
        type: DataTypes.BIGINT.UNSIGNED,
        field: "story_id",
        primaryKey: true,
      },
      problemId: {
        type: DataTypes.BIGINT.UNSIGNED,
        field: "problem_id",
        primaryKey: true,
      },
    },
    {
      tableName: "story_problems",
      timestamps: false,
    }
  );

  return StoryProblem;
};
