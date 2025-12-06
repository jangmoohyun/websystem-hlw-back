export default (sequelize, DataTypes) => {
  const Story = sequelize.define(
    "Story",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
      storyCode: {
        type: DataTypes.STRING(50),
        allowNull: false,
        unique: true,
        comment: "스토리 번호 (예: 1, 2-1, 2-2, 3-1)",
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
      foreignKey: "story_id",
    });

    Story.belongsTo(models.Story, {
      as: "nextStory",
      foreignKey: "next_story_id",
    });

    Story.belongsToMany(models.Heroine, {
      through: models.StoryHeroine,
      as: "heroines",
      foreignKey: "storyId",
      otherKey: "heroineId",
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
