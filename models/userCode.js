export default (sequelize, DataTypes) => {
  // 유저 제출 코드(사용자별 문제) 모델
  const UserCode = sequelize.define(
    "UserCode",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
      userId: {
        type: DataTypes.UUID,
        field: "user_id",
        allowNull: false,
      },
      problemId: {
        type: DataTypes.BIGINT.UNSIGNED,
        field: "problem_id",
        allowNull: false,
      },
      code: { type: DataTypes.TEXT, allowNull: true },
      content: { type: DataTypes.TEXT, allowNull: true },
      isPass: {
        type: DataTypes.BOOLEAN,
        field: "is_pass",
        defaultValue: false,
      },
      stdout: { type: DataTypes.TEXT, allowNull: true },
      createdAt: { type: DataTypes.DATE, field: "created_at", allowNull: true },
      updatedAt: { type: DataTypes.DATE, field: "updated_at", allowNull: true },
    },
    {
      tableName: "user_code",
      timestamps: false,
    }
  );

  UserCode.associate = (models) => {
    UserCode.belongsTo(models.User, { as: "user", foreignKey: "user_id" });
    UserCode.belongsTo(models.Problem, {
      as: "problem",
      foreignKey: "problem_id",
    });
  };

  return UserCode;
};
