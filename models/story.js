export default (sequelize, DataTypes) => {
  const Story = sequelize.define(
    "Story",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
      title: {
        type: DataTypes.STRING(255),
        allowNull: false,
        comment: "장 제목",
      },
      content: {
        type: DataTypes.TEXT,
        allowNull: true,
        comment: "장 내용 / 설명",
      },
      image: {
        type: DataTypes.STRING(500),
        allowNull: true,
        comment: "배경 이미지 URL",
      },
    },
    {
      tableName: "story",
      timestamps: false,
    }
  );

  Story.associate = (models) => {
    Story.hasOne(models.Script, {
      as: "script",
      foreignKey: "story_id",
    });

    Story.hasMany(models.Progress, {
      as: "progresses",
      foreignKey: {
        name: "storyId",
        field: "story_id",
        allowNull: false,
      },
      onDelete: "CASCADE",
    });
    // 문제(Problem)와 연관 (한 스토리에 여러 문제를 연결할 수 있음)
    Story.hasMany(models.Problem, {
      as: "problems",
      foreignKey: {
        name: "storyId",
        field: "story_id",
        allowNull: true,
      },
    });
  };

  return Story;
};
