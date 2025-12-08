export default (sequelize, DataTypes) => {
  // 문제(Problem) 모델: challenge/problem 정보를 담는 테이블
  const Problem = sequelize.define(
    "Problem",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
      key: { type: DataTypes.STRING(255), allowNull: true },
      title: { type: DataTypes.STRING(255), allowNull: true },
      content: { type: DataTypes.TEXT, allowNull: true },
      level: { type: DataTypes.BIGINT, allowNull: true },
      stdout: { type: DataTypes.STRING(255), allowNull: true },
      description: { type: DataTypes.TEXT, allowNull: true },
    },
    {
      tableName: "problem",
      timestamps: false,
    }
  );

  Problem.associate = (models) => {
    Problem.hasMany(models.Testcase, {
      as: "testcases",
      foreignKey: "problem_id",
    });

    Problem.belongsToMany(models.Story, {
      through: models.StoryProblem,
      as: "stories",
      foreignKey: "problemId",
      otherKey: "storyId",
    });
  };

  return Problem;
};
