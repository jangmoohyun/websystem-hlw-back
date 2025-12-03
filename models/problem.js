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
      storyId: {
        type: DataTypes.BIGINT.UNSIGNED,
        field: "story_id",
        allowNull: true,
      },
      description: { type: DataTypes.TEXT, allowNull: true },
    },
    {
      tableName: "problem",
      timestamps: false,
    }
  );

  // 연관: 문제는 여러 테스트케이스를 가질 수 있음
  Problem.associate = (models) => {
    Problem.hasMany(models.Testcase, {
      as: "testcases",
      foreignKey: "problem_id",
    });
    // 각 문제는 하나의 스토리에 연결될 수 있습니다 (옵션)
    Problem.belongsTo(models.Story, {
      as: "story",
      foreignKey: {
        name: "storyId",
        field: "story_id",
        allowNull: true,
      },
    });
  };

  return Problem;
};
