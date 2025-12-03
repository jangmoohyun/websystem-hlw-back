export default (sequelize, DataTypes) => {
  // 문제(Testcase) 모델: 각 문제의 입력/기대 출력 등을 저장
  const Testcase = sequelize.define(
    "Testcase",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
      content: { type: DataTypes.TEXT, allowNull: true },
      input: { type: DataTypes.TEXT, allowNull: true },
      expected: { type: DataTypes.TEXT, allowNull: true },
      problemId: {
        type: DataTypes.BIGINT.UNSIGNED,
        field: "problem_id",
        allowNull: false,
      },
      order: { type: DataTypes.INTEGER, allowNull: true, defaultValue: 0 },
      isPublic: {
        type: DataTypes.BOOLEAN,
        field: "is_public",
        defaultValue: false,
      },
    },
    {
      tableName: "testcase",
      timestamps: false,
    }
  );

  Testcase.associate = (models) => {
    Testcase.belongsTo(models.Problem, {
      as: "problem",
      foreignKey: "problem_id",
    });
  };

  return Testcase;
};
