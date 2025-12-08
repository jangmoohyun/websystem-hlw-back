export default (sequelize, DataTypes) => {
  const StoryHeroine = sequelize.define(
    "StoryHeroine",
    {
      id: {
        type: DataTypes.BIGINT.UNSIGNED,
        primaryKey: true,
        autoIncrement: true,
      },
    },
    {
      tableName: "story_heroine",
      timestamps: false,
    }
  );

  StoryHeroine.associate = (models) => {
    StoryHeroine.belongsTo(models.Story, {
      as: "story",
      foreignKey: {
        name: "storyId",
        field: "story_id",
        allowNull: false,
      },
      onDelete: "CASCADE",
    });

    StoryHeroine.belongsTo(models.Heroine, {
      as: "heroine",
      foreignKey: {
        name: "heroineId",
        field: "heroine_id",
        allowNull: false,
      },
      onDelete: "CASCADE",
    });
  };

  return StoryHeroine;
};
